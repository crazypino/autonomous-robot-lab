def pid_realize(Kp, Ki, Kd, ref, integ, mea_value, pre_error):
    error = ref - mea_value
    integ = integ + error
    deriv = (error - pre_error)
    output = Kp * error + Ki * integ + Kd * deriv
    pre_error = error

    return output, integ, pre_error


if __name__ == '__main__':
    Kp = 0.2
    Ki = 0.015
    Kd = 0.2
    integ = 0
    mea_value = 0
    pre_error = 0
    setpoint = 200
    for i in range(5000):
        mea_value, integ, pre_error = pid_realize(Kp, Ki, Kd, setpoint, integ, mea_value, pre_error)
        print(mea_value)
    print(mea_value)



v(t+1) = v(t) + u(t)*dt - 0.01v(t)