import rospy
from kobuki_msgs.msg import BumperEvent
from geometry_msgs.msg import Twist

def processBump(data):
            print ("Bump")
            global bump
            if (data.state == BumperEvent.PRESSED):
                bump = True
            else:
                bump = False
            rospy.loginfo("Bumper Event")
            rospy.loginfo(data.bumper)

def GoForward():
        print("Starting..")

        # initiliaze
        rospy.init_node('GoForward', anonymous=False)

        # tell user how to stop TurtleBot
        rospy.loginfo("To stop TurtleBot CTRL + C")


        # Create a publisher which can "talk" to TurtleBot and tell it to move
        # Tip: You may need to change cmd_vel_mux/input/navi to /cmd_vel if you're not using TurtleBot2
        cmd_vel = rospy.Publisher('cmd_vel_mux/input/navi', Twist, queue_size=10)
        rospy.Subscriber('mobile_base/events/bumper', BumperEvent, processBump)
        #TurtleBot will stop if we don't keep telling it to move.  How often should we tell it to move? 10 HZ
        r = rospy.Rate(10)



        #############################Cruise Control###################
        Kp = 0.2
        Ki = 0.015
        Kd = 0.2
        integ = 0
        mea_value = 0
        pre_error = 0
        setpoint = 0.3   #### default speed

        # Twist is a datatype for velocity
        move_cmd = Twist()
        # let's go forward at 0.2 m/s
        move_cmd.linear.x = 0.2
        # let's turn at 0 radians/s
        move_cmd.angular.z = 0.0

        turn_cmd = Twist()

        turn_cmd.linear.x = 0.0

        turn_cmd.angular.z = 3.14

        count = 0

        v = [0.3, 0.5, 0.6]

        # as long as you haven't ctrl + c keeping doing...
        while not rospy.is_shutdown():
            # publish the velocity
            if not bump:
                setpoint = v[count]
                mea_value, integ, pre_error = pid_realize(Kp, Ki, Kd, setpoint, integ, mea_value, pre_error)
                move_cmd.linear.x = mea_value
                cmd_vel.publish(move_cmd)
            # wait for 0.1 seconds (10 HZ) and publish again
            else:
                count = count + 1 if count < 2 else 2
                cmd_vel.publish(turn_cmd)
                bump = False
            r.sleep()



def pid_realize(Kp, Ki, Kd, ref, integ, mea_value, pre_error):
    error = ref - mea_value
    integ = integ + error
    deriv = (error - pre_error)
    output = Kp * error + Ki * integ + Kd * deriv
    pre_error = error

    return output, integ, pre_error








if  __name__  == '__main__':
    GoForward()