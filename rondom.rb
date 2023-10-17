$stdout.sync = true
N, D, Q = gets.split.map(&:to_i)
question_time = 0
list = Array.new(D) { Array.new() }
repeated_question = Hash.new()

def repeated_check(ans, h, l, r)
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

list_copy = [[]]
min_max_flag = 0
while true
  list_copy = list.map(&:dup)
  lll = rand(D)
  rrr = rand(D)
  next if lll == rrr
  next if list[lll].size == 1 || list[rrr].size == 1
  # 多対多の交換
  lll_delete_list = []
  rrr_delete_list = []
  while (lll_delete_list.size < lll_size)
    lll_delete_element = list[lll][rand(list[lll].size)]
    next if lll_delete_list.include?(lll_delete_element)
    lll_delete_list << lll_delete_element
  end
  while (rrr_delete_list.size < rrr_size)
    rrr_delete_element = list[rrr][rand(list[rrr].size)]
    next if rrr_delete_list.include?(rrr_delete_element)
    rrr_delete_list << rrr_delete_element
  end

  question_content = "#{lll_delete_list.size} #{rrr_delete_list.size} #{lll_delete_list.join(" ")} #{rrr_delete_list.join(" ")}"
  if repeated_question[question_content] == nil
    break if question_time == Q
    puts question_content
    s = gets.chomp
    repeated_question = repeated_check(s, repeated_question, lll_delete_list, rrr_delete_list)
    question_time += 1
  else
    s = repeated_question[question_content]
  end
  next if s == "="
  first_answer = s
  lll_delete_list.each { |del_l| list[lll].delete(del_l) }
  rrr_delete_list.each { |del_r| list[rrr].delete(del_r) }

  question_content = "#{list[lll].size} #{list[rrr].size} #{list[lll].join(" ")} #{list[rrr].join(" ")}"
  if repeated_question[question_content] == nil
    break if question_time == Q
    puts question_content
    s = gets.chomp
    question_time += 1
    repeated_question = repeated_check(s, repeated_question, list[lll], list[rrr])
  else
    s = repeated_question[question_content]
  end
  if s != first_answer
    list = list_copy.map(&:dup)
    next
  end
  lll_delete_list.each { |del_l| list[rrr] << del_l }
  rrr_delete_list.each { |del_r| list[lll] << del_r }
end

ans = []
for i in 0...N
  for j in 0...D
    ans << j if list_copy[j].include?(i)
  end
end

puts ans.join(" ")
