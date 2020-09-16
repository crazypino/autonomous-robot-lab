#!/usr/bin/env python
import rospy
from nav_msgs.msg import Odometry
import tf
import math
from geometry_msgs.msg import Twist, Pose


def callback(data):
    global odom_x, odom_y, euler, start_goal, count
    
    if count == 0:
        cur_x=data.pose.pose.position.x
        cur_y=data.pose.pose.position.y
        print('x_start',cur_x)
        print('y_start',cur_y)
        start_goal = [[cur_x,cur_y],[cur_x+1.5,cur_y+1.5]]
        count += 1
    odom_x = data.pose.pose.position.x
    odom_y = data.pose.pose.position.y
    odom_quat = (data.pose.pose.orientation.x, data.pose.pose.orientation.y, data.pose.pose.orientation.z, data.pose.pose.orientation.w)
    euler = tf.transformations.euler_from_quaternion(odom_quat)[2]
    

def cal_distance(x,y,xg,yg):
    return math.sqrt((xg-x)**2 + (yg-y)**2)


def main():
    global odom_x, odom_y, euler, start_goal, count
    print(1)
    count = 0
    odom_x, odom_y, euler = 0, 0, 0
    start=0
    goal=1
    vel=0.1
    k_h=0.5
    start_goal = [[0,0],[0,0]]
    rospy.init_node('Go_to_goal', anonymous = True)

    odom_sub = rospy.Subscriber("odom", Odometry, callback)

    kv = 0.2

    twist = Twist()

    goal_pub = rospy.Publisher('cmd_vel_mux/input/navi', Twist, queue_size=10)
    rate = rospy.Rate(10)
    
    
    while not rospy.is_shutdown():
        d = cal_distance(odom_x, odom_y, start_goal[goal][0], start_goal[goal][1])
        u1=start_goal[goal][0]-odom_x
        u2=start_goal[goal][1]-odom_y
        
        theta_goal=math.atan2(u2,u1)
        error=theta_goal-euler
        steering=k_h*math.atan2(math.sin(error),math.cos(error))
        print(u1)
        print(u2)
    if u1 < 0.1 and u2 < 0.1:
        twist.angular.z=0
            twist.linear.x = 0
        else:
            twist.angular.z = steering
            twist.linear.x = kv * d
        goal_pub.publish(twist)

        rate.sleep()

if  __name__  == "__main__":
    main()




