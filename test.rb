$stdout.sync = true
N, D, Q = gets.split.map(&:to_i)
ddd = D
question_time = 0
list = Array.new(D) { Array.new() }
repeated_question = Hash.new()
def repeated_check(ans,h,l,r)
  s1 = "#{l.size} #{r.size} #{l.join(" ")} #{r.join(" ")}"
  s2 = "#{r.size} #{l.size} #{r.join(" ")} #{l.join(" ")}"
  if ans == "="
    h[s1] = "="
    h[s2] = "="
  elsif ans == ">"
    h[s1] = ">"
    h[s2] = "<"
  else
    h[s1] = "<"
    h[s2] = ">"
  end
  return h
end

for i in 0...N
  list[i % D] << i
end

list_sort = [0]

for i in 1...D
  l = 0
  r = i

  while (r - l) > 0
    c = (l + r) / 2
    question_content = "#{list[i].size} #{list[list_sort[c]].size} #{list[i].join(" ")} #{list[list_sort[c]].join(" ")}"
    puts question_content
    s = gets.chomp
    repeated_question = repeated_check(s,repeated_question,list[i],list[list_sort[c]])
    question_time += 1

    if s == "="
      l = r = c
    elsif s == ">"
      l = c + 1
    elsif s == "<"
      r = c
    end
  end

  list_sort_copy = list_sort.dup
  list_sort = []

  for j in 0...i
    if j == l
      list_sort << i
    end
    list_sort << list_sort_copy[j]
  end

  list_sort << i if l == i
end

# 交換と譲渡を繰り返して良くしていく
dis2flag = 0
list_copy = [[]]
catch(:break_all) do
  while true
    while(list[list_sort[-1]].size == 1)
      list_sort.pop
      D -= 1
    end



    which = rand(Q)
    list_copy = list.map(&:dup)
    if which <= question_time
      # 交換
      lower_side = list[list_sort[0]][rand(list[list_sort[0]].size)]
      upper_side = list[list_sort[-1]][rand(list[list_sort[-1]].size)]
      throw :break_all if question_time == Q
      puts "#{1} #{1} #{lower_side} #{upper_side}"
      s = gets.chomp
      question_time += 1
      next if s != "<"

      list[list_sort[0]].delete(lower_side)
      list[list_sort[-1]].delete(upper_side)

      throw :break_all if question_time == Q
      puts "#{list[list_sort[0]].size} #{list[list_sort[-1]].size} #{list[list_sort[0]].join(" ")} #{list[list_sort[-1]].join(" ")}"
      s = gets.chomp
      question_time += 1
      if s != "<"
        list = list_copy.map(&:dup)
        next
      end

      list[list_sort[0]] << upper_side
      list[list_sort[-1]] << lower_side
    else
      # 譲渡
      upper_side = list[list_sort[-1]][rand(list[list_sort[-1]].size)]
      list[list_sort[-1]].delete(upper_side)
      # 失敗check
      throw :break_all if question_time == Q
      puts "#{list[list_sort[0]].size} #{list[list_sort[-1]].size} #{list[list_sort[0]].join(" ")} #{list[list_sort[-1]].join(" ")}"
      s = gets.chomp
      question_time += 1
      if s != "<"
        list = list_copy.map(&:dup)
        next
      end
      list[list_sort[0]] << upper_side
    end


    #確定
    list_copy = list.map(&:dup)
    # 最初のやつのcheck
    list_sort_first = list_sort[0]
    list_sort_end = list_sort[D - 1]
    [0, D-1].each do |ii|
      if ii == 0
        l = 1
        r = D - 1
        insert = list_sort_first
      else
        l = 0
        r = D - 1
        insert = list_sort_end
      end
      while l < r
        c = (l + r) / 2
        throw :break_all if question_time == Q
        puts "#{list[insert].size} #{list[list_sort[c]].size} #{list[insert].join(" ")} #{list[list_sort[c]].join(" ")}"
        s = gets.chomp
        question_time += 1
        if s == "=" && D == 2
          dis2flag = 1
          throw :break_all
        elsif s == "="
          l = r = c+1
        elsif s == ">"
          l = c + 1
        elsif s == "<"
          r = c
        end
      end

      if ii == 0
        list_sort_copy = list_sort.dup
        list_sort = []

        for j in 1...(D-1)
          if j == l
            list_sort << insert
          end

          list_sort << list_sort_copy[j]
        end

        list_sort << insert if l == D-1
      else
        list_sort_copy = list_sort.dup
        list_sort = []

        for j in 0...(D-1)
          if j == l
            list_sort << insert
          end

          list_sort << list_sort_copy[j]
        end

        list_sort << insert if l == D-1
      end
    end
  end
end

list_copy = list.map(&:dup) if dis2flag == 1
if question_time != Q
  while(true)
    break if question_time == Q
    puts "1 1 0 1"
    s = gets
    question_time += 1
  end
end

ans = []
for i in 0...N
  for j in 0...ddd
    ans << j if list_copy[j].include?(i)
  end
end

puts ans.join(" ")
