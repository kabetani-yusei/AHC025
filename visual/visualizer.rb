$AC_DATA = %w(40069 111134 97459 89771 105561 17991 134953 256491 3052 63107 162520 236832 224524 58029 27613 341675 86043 221830 31020 135952 94367 56828 147952 117849 22923 335571 9036 14754 2469 12380 252683 115149 195099 52222 126536 7146 117098 257864 25103 277093 86161 73275 49600 55635 117497 121973 116992 65365 161245 31130 327148 89511 69214 106556 26030 59727 2168 6306 138125 218009 113528 102781 97790 47291 6470 52550 97201 3657 141785 76173 301893 98290 38439 63750 182960 58869 73853 37230 44079)
$AC_DATA = $AC_DATA.map &:to_i
N, D, Q = %w(79 5 294).map &:to_i
#s = accheckみたいな感じで使う
def ac_check(left, right)
  l = 0
  r = 0
  left.each{|ll|l += $AC_DATA[ll]}
  right.each{|rr|r += $AC_DATA[rr]}
  if l == r
    return "="
  elsif l > r
    return ">"
  else
    return "<"
  end
end
output_file = []
output_file_index = -1
#1. N,D,Q = の行を消す
#2. put s =  -> out_string = に変える
#3. file.put sのところを元に戻す

#ここからは手入力
#3. getsをac_check(left, right)に変える
#4. getsの次の行 output_file[output_file_index+=1] = out_string
def comment_out()#list_copy = listのとこに追加（譲渡のとこに追加しないように注意)
ans = []
for check_i in 0...N
  for check_j in 0...ddd
    ans << check_j if list[check_j].include?(check_i)
  end
end
out_string = "#c #{ans.join(" ")}"
output_file[output_file_index+=1] = out_string
end
#最後に追加
def tuika_saig()
output_file[output_file_index += 1] = out_string
file = File.open("output.txt", "w")
output_file.each{|dd|file.put = dd}#putにsを付け加えるのを忘れずに
file.close
end
#
#
#ここから先のコードを変更する
#
#

$stdout.sync = true
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
while true
  ans = []
  for check_i in 0...N
    for check_j in 0...D
      ans << check_j if list[check_j].include?(check_i)
    end
  end
  out_string = "#c #{ans.join(" ")}"
  output_file[output_file_index+=1] = out_string
  list_copy = list.map(&:dup)
  lll = rand(D)
  rrr = rand(D)
  next if lll == rrr
  next if list[lll].size == 1 || list[rrr].size == 1
  # 多対多の交換
  lll_size = rand(1..(list[lll].size / 2))
  rrr_size = rand(1..30)
  if rrr_size == 1
    rrr_size = [lll_size - 2,1].max
  elsif rrr_size == 2
    rrr_size = lll_size + 2
  elsif rrr_size <= 4
    rrr_size = [lll_size - 1,1].max
  elsif rrr_size <= 6
    rrr_size = lll_size + 1
  else
    rrr_size = lll_size
  end
  rrr_size = [rrr_size,list[rrr].size - 1].min
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
    out_string = question_content
    s = ac_check(lll_delete_list, rrr_delete_list)
    output_file[output_file_index+=1] = out_string
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
    out_string = question_content
    s = ac_check(list[lll], list[rrr])
    output_file[output_file_index+=1] = out_string
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



out_string = ans.join(" ")
output_file[output_file_index += 1] = out_string
file = File.open("output.txt", "w")
output_file.each{|dd|file.puts dd}
file.close
