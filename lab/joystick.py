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
    


def pid_realize(Kp, Ki, Kd, ref, integ, mea_value, pre_error):
    error = ref - mea_value
    integ = integ + error
    deriv = (error - pre_error)
    output = Kp * error + Ki * integ + Kd * deriv
    pre_error = error

    return output, integ, pre_error

def main():
    global odom_x, odom_y, euler, start_goal, count
    count = 0
    odom_x, odom_y, euler = 0, 0, 0
    start=0
    goal=1
    vel=0.15
    k_h=0.35
    start_goal = [[0,0],[0,0]]
    rospy.init_node('Go_to_goal', anonymous = True)

    odom_sub = rospy.Subscriber("odom", Odometry, callback)
    
    Kp = 0.3
    Ki = 0.1
    Kd = 0.3
    integ = 0
    mea_value = 0
    pre_error = 0

    twist = Twist()

    goal_pub = rospy.Publisher('cmd_vel_mux/input/navi', Twist, queue_size=10)
    rate = rospy.Rate(10)
    count = 0
    
    while not rospy.is_shutdown():
        
        u1=start_goal[goal][0]-odom_x
        u2=start_goal[goal][1]-odom_y
        theta_goal=math.atan2(u2,u1)
        error=theta_goal-euler
        steering=k_h*math.atan2(math.sin(error),math.cos(error))
        setpoint = vel
        mea_value, integ, pre_error = pid_realize(Kp, Ki, Kd, setpoint, integ, mea_value, pre_error)
	
        if abs(odom_x-start_goal[goal][0])<0.05 and abs(odom_y-start_goal[goal][1])<0.05:
            twist.angular.z=0
            twist.linear.x=0
            start, goal = goal, start
            goal_pub.publish(twist)
            print('x', odom_x)
            print('y', odom_y)
            
        else:
            twist.angular.z=steering
            twist.linear.x=mea_value
            goal_pub.publish(twist)

        rate.sleep()

if  __name__  == "__main__":
    main()
