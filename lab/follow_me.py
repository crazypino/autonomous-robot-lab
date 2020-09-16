#!/usr/bin/env python
import rospy
from geometry_msgs.msg import Twist
from sensor_msgs.msg import LaserScan


def searchmin(s):
    mini = 20
    index = -1
    for i, num in enumerate(s):
        if 0 < num <= 10.0 and num < mini:
            mini = num
            index = i

    return [index, mini]

def callback(data):
    global dist, theta
    angmin = data.angle_min
    angmax = data.angle_max
    incremnt = data.angle_increment
    d_min = data.range_min
    d_max = data.range_max

    dist, index = searchmin(data.ranges)
    theta = index * incremnt + angmin




def main():
    global dist, theta
    rospy.init_node('follow_me', anonymous = False)
    scan_sub = rospy.Subscriber('scan', LaserScan, callback)
    twist = Twist()

    follow_pub = rospy.Publisher('cmd_vel_mux/input/navi', Twist, queue_size=10)

    rate = rospy.Rate(10)
    pre_dist = 10
    while not rospy.is_shutdown():
        if dist < 0.8:
            twist.angular.z = theta
            twist.linear.x = 1
            pre_dist = dist
        elif dist > 0.8 and pre_dist < 0.8:
            twist.angular.z = 0
            twist.linear.x = 3
            pre_dist = dist

        rate.sleep()

if __name__ == "__main__":
    main()

