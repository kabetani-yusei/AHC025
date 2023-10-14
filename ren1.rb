$stdout.sync = true
N,D,Q = gets.split.map &:to_i
Q.times{
  puts "1 1 0 1"
  s = gets
}
ans = []
for i in 0...N
  ans << i % D
end
puts ans.join(" ")
