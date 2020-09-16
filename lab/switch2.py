import rospy
from kobuki_msgs.msg import BumperEvent
from geometry_msgs.msg import Twist
from sensor_msgs.msg import Joy

def callback(data):
    global mode
    global speed1
    global speed2
    global speed3
    global stop
    global twist

    mode = data.buttons[7]
    if mode > 0:
        twist.linear.x = data.axes[1]
        twist.angular.z = data.axes[0]
    else:
        speed1 = data.buttons[1]
        speed2 = data.buttons[0]
        speed3 = data.buttons[3]
        stop = data.buttons[2]


def main():
    global twist
    global mode
    global speed1
    global speed2
    global speed3
    global stop

    twist = Twist()

    rospy.init_node('switchd', anonymous=False)
    pub_joy = rospy.Publisher('turtle1/cmd_vel', Twist, queue_size=1)
    pub_cruise = rospy.Publisher('cmd_vel_mux/input/navi', Twist, queue_size=10)
    rospy.Subscriber("joy", Joy, callback)

    rate = rospy.Rate(10)

    #############################Cruise Control###################
    Kp = 0.2
    Ki = 0.015
    Kd = 0.2
    integ = 0
    mea_value = 0
    pre_error = 0
    setpoint = 0.3  #### default speed
    twist2 = Twist()
    while not rospy.is_shutdown():
        if mode:
            rospy.loginfo("joystick control")
            pub_joy.publish(twist)
        else:
            if speed1 > 0:
                setpoint = 0.3
            elif speed2 > 0:
                setpoint = 0.5
            elif speed3 > 0:
                setpoint = 0.6
            elif stop > 0:
                setpoint = 0
            mea_value, integ, pre_error = pid_realize(Kp, Ki, Kd, setpoint, integ, mea_value, pre_error)
            twist2.linear.x = mea_value
            pub_cruise.publish(twist2)
        rate.sleep()







def pid_realize(Kp, Ki, Kd, ref, integ, mea_value, pre_error):
    error = ref - mea_value
    integ = integ + error
    deriv = (error - pre_error)
    output = Kp * error + Ki * integ + Kd * deriv
    pre_error = error

    return output, integ, pre_error



if __name__ == "__main__":
    main()
