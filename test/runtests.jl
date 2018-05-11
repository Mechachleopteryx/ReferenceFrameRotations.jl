VERSION >= v"0.7.0-DEV.2036" && using Test
VERSION <  v"0.7.0-DEV.2036" && using Base.Test

using ReferenceFrameRotations

# Available rotations.
rot_seq_array = ["XYX",
                 "XYZ",
                 "XZX",
                 "XZY",
                 "YXY",
                 "YXZ",
                 "YZX",
                 "YZY",
                 "ZXY",
                 "ZXZ",
                 "ZYX",
                 "ZYZ"]

# Number of samples.
samples = 1000

################################################################################
#                                  TEST: DCM
################################################################################

println("Testing DCM functions ($samples samples)...")

for k = 1:samples
    # Rotations
    # =========

    # X Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a DCM that rotates about X axis.
    dcm = create_rotation_matrix(ang, 'x')

    # Create a vector that does not have X component.
    v = [0;randn();randn()]

    # Rotate the reference using the DCM.
    v_r = dcm*v

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Y Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a DCM that rotates about Y axis.
    dcm = create_rotation_matrix(ang, 'y')

    # Create a vector that does not have Y component.
    v = [randn();0;randn()]

    # Rotate the reference using the DCM.
    v_r = dcm*v

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Z Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a DCM that rotates about Z axis.
    dcm = create_rotation_matrix(ang, 'z')

    # Create a vector that does not have Z component.
    v = [randn();randn();0]

    # Rotate the reference using the DCM.
    v_r = dcm*v

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Orthonormality
    # ==============

    # Sample two DCMs.
    dcm1 = create_rotation_matrix(randn(), rand(['x','y','z']))
    dcm2 = create_rotation_matrix(randn(), rand(['x','y','z']))

    # Create another DCM.
    dcm3 = dcm2*dcm1

    # Check if they are orthonormal.
    @test norm(dcm3'-inv(dcm1)*inv(dcm2)) < 1e-10
end

################################################################################
#                              TEST: Quaternions
################################################################################

println("Testing Quaternions functions ($samples samples)...")

for i = 1:samples
    # Rotations
    # =========

    # X Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a quaternion that rotates about X axis.
    q = angle2quat(ang, 0.0, 0.0, "XYZ")

    # Create a vector that does not have X component.
    v = [0;randn();randn()]

    # Rotate the reference using the quaternion.
    v_r = vect(inv(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[1]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Y Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a quaternion that rotates about Y axis.
    q = angle2quat(ang, 0.0, 0.0, "YXZ")

    # Create a vector that does not have Y component.
    v = [randn();0;randn()]

    # Rotate the reference using the quaternion.
    v_r = vect(inv(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[2]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Z Axis
    # ------

    # Sample an angle.
    ang = -pi + 2pi*rand()

    # Create a quaternion that rotates about Z axis.
    q = angle2quat(ang, 0.0, 0.0, "ZXY")

    # Create a vector that does not have Z component.
    v = [randn();randn();0]

    # Rotate the reference using the quaternion.
    v_r = vect(inv(q)*v*q)

    # Get the sine of the angle between the representations.
    sin_ang = (cross(v_r, v)/norm(v)^2)[3]

    # Test the angle between the two representations.
    @test abs(sin(ang)-sin_ang) < 1e-10

    # Other functions
    # ===============

    # eye
    # ---

    # Create a random quaternion with Float32 type.
    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    q = q/norm(q)

    # Creata an identity quaternion using many methods.
    q_eye_1 = eye(Quaternion)
    q_eye_2 = eye(Quaternion{Float32})
    q_eye_3 = eye(q)

    # Check if the types are correct.
    @test eltype(q_eye_1.q0) != eltype(q.q0)
    @test eltype(q_eye_2.q0) == eltype(q.q0)
    @test eltype(q_eye_3.q0) == eltype(q.q0)

    # Check if the value of the quaternion is correct.
    @test norm(vect(q_eye_3)) == 0.0
    @test real(q_eye_3) == 1.0

    # zeros
    # -----

    # Create a random quaternion with Float32 type.
    q = Quaternion{Float32}(randn(), randn(), randn(), randn())
    q = q/norm(q)

    # Creata a zero quaternion using many methods.
    q_zeros_1 = zeros(Quaternion)
    q_zeros_2 = zeros(Quaternion{Float32})
    q_zeros_3 = zeros(q)

    # Check if the types are correct.
    @test eltype(q_zeros_1.q0) != eltype(q.q0)
    @test eltype(q_zeros_2.q0) == eltype(q.q0)
    @test eltype(q_zeros_3.q0) == eltype(q.q0)

    # Check if the value of the quaternion is correct.
    @test norm(q_zeros_3) == 0.0
end

################################################################################
#                          TEST: DCM <=> Euler Angles
################################################################################

println("Testing DCM <=> Euler Angles conversions ($samples samples)...")

for k = 1:samples
    for rot_seq in rot_seq_array
        # Sample three angles form a uniform distribution [-pi,pi].
        eulerang = EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rot_seq)

        # Get the error matrix related to the conversion from DCM => Euler Angles =>
        # DCM.
        error = angle2dcm(dcm2angle(angle2dcm(eulerang),rot_seq)) -
        angle2dcm(eulerang)

        # If everything is fine, the norm of the matrix error should be small.
        @test norm(error) < 1e-10
    end
end

println("Testing DCM <=> Small Euler Angles conversions ($samples samples)...")

for k = 1:samples
    # Sample three angles form a uniform distribution [-0.0001,0.0001].
    eulerang = EulerAngles(-0.0001 + 0.0002*rand(),
                           -0.0001 + 0.0002*rand(),
                           -0.0001 + 0.0002*rand(),
                           "XYZ")

    # Get the error between the exact rotation and the small angle
    # approximation.
    error = angle2dcm(eulerang) -
    smallangle2dcm(eulerang.a1, eulerang.a2, eulerang.a3)

    # If everything is fine, the norm of the matrix error should be small.
    @test norm(error) < 1e-7
end

################################################################################
#                          TEST: DCM <=> Quaternions
################################################################################

println("Testing DCM <=> Quaternion conversions ($samples samples)...")

for k = 1:samples
    # Conversion test
    # ===============

    # Create a random quaternion.
    q1 = Quaternion(randn(), randn(), randn(), rand())
    q1 = q1/norm(q1)

    # Make sure that the real part is positive.
    (q1.q0 < 0) && (q1 *= -1)

    # Create a random DCM using Euler Angles.
    dcm2 = angle2dcm(randn(), randn(), randn(), rot_seq_array[rand(1:9)])

    # Convert the quaternion in DCM and the DCM in quaternion.
    q2   = dcm2quat(dcm2)
    dcm1 = quat2dcm(q1)

    # Do the inverse conversion and compare.
    error_dcm = dcm2 - quat2dcm(q2)
    @test norm(error_dcm) < 1e-10

    error_q = q1 - dcm2quat(dcm1)
    @test norm(error_q) < 1e-10

    # Multiplication test
    # ===================

    # Sample a 3x1 vector.
    v = randn(3)

    # Compute the rotated vector using the quaternions.
    v_rot_q = vect(inv(q1*q2)*v*(q1*q2))

    # Compute the rotated vector using the DCMs.
    v_rot_dcm = dcm2*dcm1*v

    # Compare.
    @test norm(v_rot_q-v_rot_dcm) < 1e-10
end

################################################################################
#                         Euler Angles <=> Quaternions
################################################################################

println("Testing Euler Angles <=> Quaternion conversions...")

for rot_seq in rot_seq_array
    println("    Rotation sequence $rot_seq ($samples samples)...")

    for k = 1:samples
        # Sample a vector.
        v = randn(3)

        # Sample three angles form a uniform distribution [-pi,pi].
        eulerang = EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rot_seq)

        # Rotate the vector using a DCM (which was already tested).
        DCM = angle2dcm(eulerang)
        rv_dcm = DCM*v

        # Rotate the vector using a quaternion.
        q = angle2quat(eulerang)
        rv_quat = vect(inv(q)*v*q)

        # Compare.
        @test norm(rv_quat-rv_dcm) < 1e-10
    end
end

println("Testing Small Euler Angles <=> Quaternion conversions ($samples samples)...")

for k = 1:samples
    # Sample three angles form a uniform distribution [-0.0001,0.0001].
    eulerang = EulerAngles(-0.0001 + 0.0002*rand(),
                           -0.0001 + 0.0002*rand(),
                           -0.0001 + 0.0002*rand(),
                           "XYZ")

    # Get the error between the exact rotation and the small angle
    # approximation.
    error = angle2quat(eulerang) -
            smallangle2quat(eulerang.a1, eulerang.a2, eulerang.a3)

    # If everything is fine, the norm of the matrix error should be small.
    @test norm(error) < 1e-7
end

################################################################################
#                       Euler Angle Axis <=> Quaternions
################################################################################

println("Testing Euler Angle Axis <=> Quaternion conversions ($samples samples)...")

for k = 1:samples
    # Sample a vector that will be aligned with the Euler angle.
    v = [randn();randn();randn()]
    v = v/norm(v)

    # Sample a angle between (0,2π).
    a = 2*pi*rand()

    # Create the Euler Angle and Axis representation.
    angleaxis = EulerAngleAxis(a,v)

    # Convert to quaternion.
    q = angleaxis2quat(angleaxis)

    # Convert back to Euler Angle and Axis.
    angleaxis_conv = quat2angleaxis(q)

    # Compare.
    @test  abs(angleaxis_conv.a - a) < 1e-10
    @test norm(angleaxis_conv.v - v) < 1e-10

    # Rotate a vector aligned with the Euler axis using the quaternion.
    r     = v*randn()
    r_rot = vect(inv(q)*r*q)

    # The vector representation must be the same after the rotation.
    @test norm(r-r_rot) < 1e-10
end

################################################################################
#                               TEST: Kinematics
################################################################################

# DCM
# ==============================================================================

println("Testing the kinematics for DCMs ($samples samples)...")

for i = 1:samples
    # Create a random DCM.
    q      = Quaternion(randn(), randn(), randn(), randn())
    q      = q/norm(q)
    Dba0   = quat2dcm(q)

    # Create a random velocity vector.
    wba_a = randn(3)

    # Propagate the initial DCM using the sampled velocity vector.
    Δ   = 0.0001
    Dba = copy(Dba0)
    for k = 1:1000
        dDba = ddcm(Dba,Dba0*wba_a)

        Dba  = Dba + dDba*Δ
    end

    # In the end, the vector aligned with w must not change.
    v1 = Dba0*wba_a
    v2 = Dba*wba_a

    @test norm(v2-v1) < 1e-10
end

# Quaternions
# ==============================================================================

println("Testing the kinematics for Quaternions ($samples samples)...")

for i = 1:samples
    # Create a random quaternion.
    qba0 = Quaternion(randn(), randn(), randn(), randn())
    qba0 = qba0/norm(qba0)

    # Create a random velocity vector.
    wba_a = randn(3)

    # Propagate the initial DCM using the sampled velocity vector.
    Δ   = 0.0001
    qba = copy(qba0)
    for k = 1:1000
        dqba = dquat(qba,vect(inv(qba)*wba_a*qba))

        qba  = qba + dqba*Δ
    end

    # In the end, the vector aligned with w must not change.
    v1 = vect(inv(qba0)*wba_a*qba0)
    v2 = vect(inv(qba)*wba_a*qba)

    @test norm(v2-v1) < 1e-10
end

################################################################################
#                           TESTE: Compose Rotations
################################################################################

# DCMs
# ==============================================================================

println("Testing the compose rotations for DCMs ($samples samples)...")

for i = 1:samples
    # Sample 8 DCMs.
    D1 = angle2dcm(EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rand(rot_seq_array)))

    D2 = angle2dcm(EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rand(rot_seq_array)))

    D3 = angle2dcm(EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rand(rot_seq_array)))

    D4 = angle2dcm(EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rand(rot_seq_array)))

    D5 = angle2dcm(EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rand(rot_seq_array)))

    D6 = angle2dcm(EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rand(rot_seq_array)))

    D7 = angle2dcm(EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rand(rot_seq_array)))

    D8 = angle2dcm(EulerAngles(-pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               -pi + 2*pi*rand(),
                               rand(rot_seq_array)))

    # Test the function `compose_rotation`.
    @test                   D2*D1 ≈ compose_rotation(D1,D2)                   atol=1e-14
    @test                D3*D2*D1 ≈ compose_rotation(D1,D2,D3)                atol=1e-14
    @test             D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4)             atol=1e-14
    @test          D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5)          atol=1e-14
    @test       D6*D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5,D6)       atol=1e-14
    @test    D7*D6*D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5,D6,D7)    atol=1e-14
    @test D8*D7*D6*D5*D4*D3*D2*D1 ≈ compose_rotation(D1,D2,D3,D4,D5,D6,D7,D8) atol=1e-14

end

# Quaternions
# ==============================================================================

println("Testing the compose rotations for Quaternions ($samples samples)...")

for i = 1:samples
    # Sample 8 quaternions.
    q1 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q2 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q3 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q4 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q5 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q6 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q7 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    q8 = angle2quat(EulerAngles(-pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                -pi + 2*pi*rand(),
                                rand(rot_seq_array)))

    # Test the function `compose_rotation`.
    @test                   (q1*q2)[:] ≈ compose_rotation(q1,q2)[:]                   atol=1e-14
    @test                (q1*q2*q3)[:] ≈ compose_rotation(q1,q2,q3)[:]                atol=1e-14
    @test             (q1*q2*q3*q4)[:] ≈ compose_rotation(q1,q2,q3,q4)[:]             atol=1e-14
    @test          (q1*q2*q3*q4*q5)[:] ≈ compose_rotation(q1,q2,q3,q4,q5)[:]          atol=1e-14
    @test       (q1*q2*q3*q4*q5*q6)[:] ≈ compose_rotation(q1,q2,q3,q4,q5,q6)[:]       atol=1e-14
    @test    (q1*q2*q3*q4*q5*q6*q7)[:] ≈ compose_rotation(q1,q2,q3,q4,q5,q6,q7)[:]    atol=1e-14
    @test (q1*q2*q3*q4*q5*q6*q7*q8)[:] ≈ compose_rotation(q1,q2,q3,q4,q5,q6,q7,q8)[:] atol=1e-14

end
