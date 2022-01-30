@testset "unsqueeze" begin
  x = randn(2, 3, 2)
  @test @inferred(unsqueeze(x, 1)) == reshape(x, 1, 2, 3, 2)
  @test @inferred(unsqueeze(x, 2)) == reshape(x, 2, 1, 3, 2)
  @test @inferred(unsqueeze(x, 3)) == reshape(x, 2, 3, 1, 2)
  @test @inferred(unsqueeze(x, 4)) == reshape(x, 2, 3, 2, 1)

  @test unsqueeze(2)(x) == unsqueeze(x, 2)
end

@testset "stack and unstack" begin
  x = randn(3,3)
  stacked = stack([x, x], 2)
  @test size(stacked) == (3,2,3)

  stacked_array=[ 8 9 3 5; 9 6 6 9; 9 1 7 2; 7 4 10 6 ]
  unstacked_array=[[8, 9, 9, 7], [9, 6, 1, 4], [3, 6, 7, 10], [5, 9, 2, 6]]
  @test unstack(stacked_array, 2) == unstacked_array
  @test stack(unstacked_array, 2) == stacked_array
  @test stack(unstack(stacked_array, 1), 1) == stacked_array
end

@testset "batch and unbatch" begin
  stacked_array=[ 8 9 3 5
                  9 6 6 9
                  9 1 7 2
                  7 4 10 6 ]
  unstacked_array=[[8, 9, 9, 7], [9, 6, 1, 4], [3, 6, 7, 10], [5, 9, 2, 6]]
  @test unbatch(stacked_array) == unstacked_array
  @test batch(unstacked_array) == stacked_array

  # no-op for vector of non-arrays
  @test batch([1,2,3]) == [1,2,3]
  @test unbatch([1,2,3]) == [1,2,3]

  # generic iterable
  @test batch(ones(2) for i=1:3) == ones(2, 3)
  @test unbatch(ones(2, 3)) == [ones(2) for i=1:3]
end

@testset "flatten" begin
    x = randn(Float32, 10, 10, 3, 2)
    @test size(flatten(x)) == (300, 2)
end

@testset "normalise" begin
    x = randn(Float32, 3, 2, 2)
    @test normalise(x) == normalise(x; dims=3)
end

@testset "chunk" begin
    cs = chunk(collect(1:10), 3)
    @test length(cs) == 3
    @test cs[1] == [1, 2, 3, 4]
    @test cs[2] == [5, 6, 7, 8]
    @test cs[3] == [9, 10]
end

@testset "frequencies" begin
    d = frequencies(['a','b','b'])
    @test d == Dict('a' => 1, 'b' => 2)
end

@testset "rpad" begin
    @test rpad([1, 2], 4, 0) == [1, 2, 0, 0]
    @test rpad([1, 2, 3], 2, 0) == [1,2,3]
end

@testset "batchseq" begin
    bs = batchseq([[1, 2, 3], [4, 5]], 0)
    @test bs[1] == [1, 4]
    @test bs[2] == [2, 5]
    @test bs[3] == [3, 0]

    bs = batchseq([[1, 2, 3], [4, 5]], -1)
    @test bs[1] == [1, 4]
    @test bs[2] == [2, 5]
    @test bs[3] == [3, -1]
end