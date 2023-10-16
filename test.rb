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
break_time = 0
question_time_copy = question_time
catch(:break_all) do
  while true
    while(list[list_sort[-1]].size == 1)
      list_sort.pop
      D -= 1
    end
    break if D == 1
    if question_time_copy == question_time
      break_time += 1
      D -= 1 if break_time >= (N/D) + D
    else
      break_time = 0
    end
    question_time_copy = question_time

    which = rand(4)
    list_copy = list.map(&:dup)
    if which <= 2
      # 交換
      lower_side = list[list_sort[0]][rand(list[list_sort[0]].size)]
      upper_side = list[list_sort[-1]][rand(list[list_sort[-1]].size)]
      question_content = "#{1} #{1} #{lower_side} #{upper_side}"
      if repeated_question[question_content] == nil
        throw :break_all if question_time == Q
        puts question_content
        s = gets.chomp
        repeated_question = repeated_check(s, repeated_question, [lower_side], [upper_side])
        question_time += 1
      else
        s = repeated_question[question_content]
      end
      next if s != "<"

      list[list_sort[0]].delete(lower_side)
      list[list_sort[-1]].delete(upper_side)


      question_content = "#{list[list_sort[0]].size} #{list[list_sort[-1]].size} #{list[list_sort[0]].join(" ")} #{list[list_sort[-1]].join(" ")}"
      if repeated_question[question_content] == nil
        throw :break_all if question_time == Q
        puts question_content
        s = gets.chomp
        question_time += 1
        repeated_question = repeated_check(s,repeated_question,list[list_sort[0]],list[list_sort[-1]])
      else
        s = repeated_question[question_content]
      end
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
      question_content = "#{list[list_sort[0]].size} #{list[list_sort[-1]].size} #{list[list_sort[0]].join(" ")} #{list[list_sort[-1]].join(" ")}"
      if repeated_question[question_content] == nil
        throw :break_all if question_time == Q
        puts question_content
        s = gets.chomp
        question_time += 1
        repeated_question = repeated_check(s,repeated_question,list[list_sort[0]],list[list_sort[-1]])
      else
        s = repeated_question[question_content]
      end
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
        question_content = "#{list[insert].size} #{list[list_sort[c]].size} #{list[insert].join(" ")} #{list[list_sort[c]].join(" ")}"
        if repeated_question[question_content] == nil
          throw :break_all if question_time == Q
          puts question_content
          s = gets.chomp
          question_time += 1
          repeated_question = repeated_check(s,repeated_question,list[insert],list[list_sort[c]])
        else
          s = repeated_question[question_content]
        end
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
