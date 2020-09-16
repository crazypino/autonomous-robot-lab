import rospy
from geometry_msgs.msg import Twist
from konuki.msgs.msg import SensorState

def Callback(data):
    global bottom, prev, state

    bottom = data.bottom
    for i in range(3):
        if prev[i] - bottom[i] > 100:
            state = i
        prev[i] = bottom[i]


    rospy.loginfo(state)
    rospy.loginfo(data.bottom)




def main():

    global bottom, prev, state

    bottom = [0] * 3
    prev = [0] * 3
    state = 1

    rospy.init_node('Follow the line', anonymous = False)

    cliff_sub = rospy.Subscriber("/mobile_base/sensors/core", SensorState, Callback)

    twist = Twist()

    cliff_pub = rospy.Publisher('cmd_vel_mux/input/navi', Twist, queue_size=10)

    rate = rospy.Rate(10)

    while not rospy.is_shutdown():

        if state == 1:
            twist.linear.x = 1
            twist.angular.z = 0
            cliff_pub.publish(twist)
        elif state == 0:
            twist.linear.x = 0
            twist.angular.z = 0.2
            cliff_pub.publish(twist)
        elif state == 2:
            twist.linear.x = 0
            twist.angular.z = -0.2
            cliff_pub.publish(twist)


        rate.sleep()