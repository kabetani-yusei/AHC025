#inフォルダーにあるやつ　->　out フォルダーに変える
score_list = Array.new(101,0)
for file_num in 0..99
file_name = "%04d" % file_num
lines = File.readlines("./in/" + file_name + ".txt")
N, D, Q = lines[0].split.map &:to_i
$AC_DATA = lines[1].split.map &:to_i
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
s = ac_check(left, right)
output_file[output_file_index+=1] = out_string

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
min_max_flag = 0
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

  which = rand(5)
  # 多対多の交換
  if which <= 3
    next if list[lll].size == 1 || list[rrr].size == 1
    lll_size_rand = rand(100)
    lll_size = 2
    if lll_size_rand <= 4
      lll_size = 3
    elsif lll_size_rand <= 19
      lll_size = 2
    else
      lll_size = 1
    end
    lll_size = [lll_size, list[lll].size - 1].min
    rrr_size = lll_size
    rrr_size = [rrr_size, list[rrr].size - 1].min
    lll_size = rrr_size = 1 if question_time <= (Q/2)
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
  else
    # 挿入
    next if list[rrr].size == 1
    upper_side = list[rrr][rand(list[rrr].size)]
    list[rrr].delete(upper_side)

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
    if s != "<"
      list = list_copy.map(&:dup)
      next
    end
    list[lll] << upper_side
  end
end




ans = []
score = Array.new(D){Array.new()}
for i in 0...N
  for j in 0...D
    ans << j if list_copy[j].include?(i)
    score[j] << $AC_DATA[i] if list_copy[j].include?(i)
  end
end

heikin = $AC_DATA.sum / D
bunsan = 0
score.each{|ss_score|bunsan += (ss_score.sum-heikin)**2}
score_list[file_num+1] = bunsan


out_string = ans.join(" ")
output_file[output_file_index += 1] = out_string
file = File.open("./out/" + file_name + ".txt", "w")
output_file.each{|dd|file.puts dd}
file.close
end

score_list[0] = score_list.sum
file = File.open("score.txt", "w")
score_list.each{|dd|file.puts dd}
file.close
