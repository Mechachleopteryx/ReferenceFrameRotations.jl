# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Desription
# ==============================================================================
#
#   Tests related to the orthonormalization of DCMs.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# File: ./src/dcm.jl
# ==================

# Functions: orthonormalize
# -------------------------

@testset "DCM orthonormalization" begin
    ang_x = -π + 2π * rand()
    ang_y = -π + 2π * rand()
    ang_z = -π + 2π * rand()
    α     = 1 + rand()

    D = create_rotation_matrix(ang_x, :X) *
        create_rotation_matrix(ang_y, :Y) *
        create_rotation_matrix(ang_z, :Z)

    D1 = hcat(D[:, 1]*α, D[:, 2],   D[:, 3])
    D2 = hcat(D[:, 1],   D[:, 2]*α, D[:, 3])
    D3 = hcat(D[:, 1],   D[:, 2],   D[:, 3]*α)
    D4 = hcat(D[:, 1]*α, D[:, 2]*α, D[:, 3])
    D5 = hcat(D[:, 1],   D[:, 2]*α, D[:, 3]*α)
    D6 = hcat(D[:, 1]*α, D[:, 2],   D[:, 3]*α)

    @test norm(D - orthonormalize(D1)) ≈ 0 atol=1e-15
    @test norm(D - orthonormalize(D2)) ≈ 0 atol=1e-15
    @test norm(D - orthonormalize(D3)) ≈ 0 atol=1e-15
    @test norm(D - orthonormalize(D4)) ≈ 0 atol=1e-15
    @test norm(D - orthonormalize(D5)) ≈ 0 atol=1e-15
    @test norm(D - orthonormalize(D6)) ≈ 0 atol=1e-15
end
