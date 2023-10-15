$stdout.sync = true
N, D, Q = gets.split.map(&:to_i)
question_time = 0
list = Array.new(D) { Array.new() }

for i in 0...N
  list[i % D] << i
end

list_sort = [0]

for i in 1...D
  l = 0
  r = i

  while (r - l) > 0
    c = (l + r) / 2
    puts "#{list[i].size} #{list[list_sort[c]].size} #{list[i].join(" ")} #{list[list_sort[c]].join(" ")}"
    s = gets.chomp
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
dis2flag = 1
list_copy = [[]]
catch(:break_all) do
  while true
    # 交換
    list_copy = list.map(&:dup)
    lower_side = list[list_sort[0]][rand(list[list_sort[0]].size)]
    upper_side = list[list_sort[-1]][rand(list[list_sort[-1]].size)]
    list[list_sort[0]].delete(lower_side)
    list[list_sort[-1]].delete(upper_side)
    list[list_sort[0]] << upper_side
    list[list_sort[-1]] << lower_side
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

      # 失敗のとき
      if (l == 1 && ii == 0 && D != 2)
        list = list_copy.map(&:dup)
        break
      end

      if (l == D-1 && ii == 0 && D != 2)
        throw :break_all if question_time == Q
        puts "#{list[list_sort[1]].size} #{list[list_sort[D-1]].size} #{list[list_sort[1]].join(" ")} #{list[list_sort[D-1]].join(" ")}"
        s = gets.chomp
        question_time += 1

        if s == ">"
          list = list_copy.map(&:dup)
          break
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



if dis2flag == 1
  list_copy = list.map(&:dup)
  while(true)
    break if question_time == Q
    puts "1 1 0 1"
    s = gets
    question_time += 1
  end
end


ans = []
for i in 0...N
  for j in 0...D
    ans << j if list_copy[j].include?(i)
  end
end

puts ans.join(" ")