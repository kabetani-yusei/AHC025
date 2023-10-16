$stdout.sync = true
N, D, Q = gets.split.map(&:to_i)
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


# 交換と譲渡を繰り返して良くしていく
list_copy = [[]]
while true
    which = rand(10)
    list_copy = list.map(&:dup)
    if which <= 9
      # 交換
      lll = rand(D)
      rrr = rand(D)
      next if lll == rrr
      next if list[lll].size == 1 || list[rrr].size == 1
      question_content = "#{list[lll].size} #{list[rrr].size} #{list[lll].join(" ")} #{list[rrr].join(" ")}"
      if repeated_question[question_content] == nil
        break if question_time == Q
        puts question_content
        s = gets.chomp
        question_time += 1
        repeated_question = repeated_check(s,repeated_question,list[lll],list[rrr])
      else
        s = repeated_question[question_content]
      end
      next if s == "="
      (lll, rrr = rrr, lll) if s == ">"


      lower_side = list[lll][rand(list[lll].size)]
      upper_side = list[rrr][rand(list[rrr].size)]
      question_content = "#{1} #{1} #{lower_side} #{upper_side}"
      if repeated_question[question_content] == nil
        break if question_time == Q
        puts question_content
        s = gets.chomp
        repeated_question = repeated_check(s, repeated_question, [lower_side], [upper_side])
        question_time += 1
      else
        s = repeated_question[question_content]
      end
      next if s != "<"

      list[lll].delete(lower_side)
      list[rrr].delete(upper_side)


      question_content = "#{list[lll].size} #{list[rrr].size} #{list[lll].join(" ")} #{list[rrr].join(" ")}"
      if repeated_question[question_content] == nil
        break if question_time == Q
        puts question_content
        s = gets.chomp
        question_time += 1
        repeated_question = repeated_check(s,repeated_question,list[lll],list[rrr])
      else
        s = repeated_question[question_content]
      end
      if s != "<"
        list = list_copy.map(&:dup)
        next
      end

      list[lll] << upper_side
      list[rrr] << lower_side
    else
      # 譲渡
      lll = rand(D)
      rrr = rand(D)
      next if lll == rrr


      question_content = "#{list[lll].size} #{list[rrr].size} #{list[lll].join(" ")} #{list[rrr].join(" ")}"
      if repeated_question[question_content] == nil
        break if question_time == Q
        puts question_content
        s = gets.chomp
        question_time += 1
        repeated_question = repeated_check(s,repeated_question,list[lll],list[rrr])
      else
        s = repeated_question[question_content]
      end
      next if s == "="
      (lll, rrr = rrr, lll) if s == ">"
      next if list[rrr].size == 1

      upper_side = list[rrr][rand(list[rrr].size)]
      list[rrr].delete(upper_side)
      # 失敗check
      question_content = "#{list[lll].size} #{list[rrr].size} #{list[lll].join(" ")} #{list[rrr].join(" ")}"
      if repeated_question[question_content] == nil
        break if question_time == Q
        puts question_content
        s = gets.chomp
        question_time += 1
        repeated_question = repeated_check(s,repeated_question,list[lll],list[rrr])
      else
        s = repeated_question[question_content]
      end
      if s != "<"
        list = list_copy.map(&:dup)
        next
      end
      list[lll] << upper_side
    end
end

ans = []
for i in 0...N
  for j in 0...D
    ans << j if list_copy[j].include?(i)
  end
end

puts ans.join(" ")
