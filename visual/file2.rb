#inフォルダーにあるやつ　->　out フォルダーに変える
score_list = Array.new(101,0)
for file_num in 0..99
file_name = "%04d" % file_num
lines = File.readlines("./in/" + file_name + ".txt")
N, D, Q = lines[0].split.map &:to_i
ddd = D
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


#
#
#ここから先のコードを変更する
#
#

$stdout.sync = true
ddd = D
question_time = 0
list = Array.new(D) { Array.new() }
repeated_question = Hash.new()

#トポロジカルソートっぽく1対1の既存質問を避ける
#重みもつける->=なら0で、
$up_to_down_tree = Array.new(N){Array.new(N, -1)}
$dist = Array.new(N,0)
$single_known = -1
def deeps(a,b,w,n)
  $dist[a] = 1
  if a == b
    if w == 0
      $single_known = 0
    else
      $single_known = 1
    end
  end
  for i in 0...n
    next if $dist[i] == 1
    next if $up_to_down_tree[a][i] == -1
    deeps(i,b,w += $up_to_down_tree[a][i],n)#0なら"=", 1なら">"
  end
end
def single_known_check(a,b,n)
  $single_known = -1
  $dist = Array.new(n,0)
  deeps(a,b,0,n)
  if $single_known == 1
    return ">"
  elsif $single_known == 0
    return "="
  end
  $dist = Array.new(n,0)
  deeps(b,a,0,n)
  if $single_known == 1
    return "<"
  elsif $single_known == 0
    return "="
  end
  return nil
end


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
roop_num = 0
change_flag = 0
while true
  ans = []
  for check_i in 0...N
    for check_j in 0...ddd
      ans << check_j if list[check_j].include?(check_i)
    end
  end
  out_string = "#c #{ans.join(" ")}"
  output_file[output_file_index+=1] = out_string
  list_copy = list.map(&:dup)
  lll = rand(D)
  rrr = rand(D)
  next if lll == rrr

  roop_num += 1 if change_flag == 0
  if change_flag == 1
    roop_num = 0
    change_flag = 0
  end

  which = rand(20)
  # 多対多の交換
  if which <= HENKA || roop_num>N*2
    next if list[lll].size == 1 || list[rrr].size == 1
    lr_rand = rand(2)
    if lr_rand == 0
      lll_size, rrr_size = 2, 1
    elsif lr_rand == 1
      lll_size, rrr_size = 2, 2
    end
    one_rand = rand(20)
    lll_size = rrr_size = 1 if roop_num <= N*2
    lll_size = [1, [list[lll].size - 1, lll_size].min].max
    rrr_size = [1, [list[rrr].size - 1, rrr_size].min].max
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
    if lll_size == 1 && rrr_size == 1
      single_check = single_known_check(lll_delete_list[0], rrr_delete_list[0], N)
      if single_check == nil
        break if question_time == Q
        out_string = question_content
        s = ac_check(lll_delete_list, rrr_delete_list)
        output_file[output_file_index+=1] = out_string
        repeated_question = repeated_check(s, repeated_question, lll_delete_list, rrr_delete_list)
        question_time += 1
        if s == "="
          $up_to_down_tree[lll_delete_list[0]][rrr_delete_list[0]] = 0
          $up_to_down_tree[rrr_delete_list[0]][lll_delete_list[0]] = 0
        elsif s == "<"
          $up_to_down_tree[rrr_delete_list[0]][lll_delete_list[0]] = 1
        elsif s == ">"
          $up_to_down_tree[lll_delete_list[0]][rrr_delete_list[0]] = 1
        end
      else
        s = single_check
      end
    else
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
    end
    next if s == "="
    first_answer = s
    lll_delete_list.each { |del_l| list[lll].delete(del_l) }
    rrr_delete_list.each { |del_r| list[rrr].delete(del_r) }

    question_content = "#{list[lll].size} #{list[rrr].size} #{list[lll].join(" ")} #{list[rrr].join(" ")}"
    if list[lll].size == 1 && list[rrr].size == 1
      single_check = single_known_check(list[lll][0], list[rrr][0], N)
      if single_check == nil
        break if question_time == Q
        out_string = question_content
        s = ac_check(list[lll],list[rrr])
        output_file[output_file_index+=1] = out_string
        repeated_question = repeated_check(s, repeated_question, [list[lll][0]], [list[rrr][0]])
        question_time += 1
        if s == "="
          $up_to_down_tree[list[lll][0]][list[rrr][0]] = 0
          $up_to_down_tree[list[rrr][0]][list[lll][0]] = 0
        elsif s == "<"
          $up_to_down_tree[list[rrr][0]][list[lll][0]] = 1
        elsif s == ">"
          $up_to_down_tree[list[lll][0]][list[rrr][0]] = 1
        end
      else
        s = single_check
      end
    else
      if repeated_question[question_content] == nil
        break if question_time == Q
        out_string = question_content
        s = ac_check(list[lll],list[rrr])
        output_file[output_file_index+=1] = out_string
        repeated_question = repeated_check(s, repeated_question, list[lll], list[rrr])
        question_time += 1
      else
        s = repeated_question[question_content]
      end
    end
    if s != first_answer
      list = list_copy.map(&:dup)
      next
    end
    change_flag = 1
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
      s = ac_check(list[lll],list[rrr])
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
    change_flag = 1
    list[lll] << upper_side
  end
end

#
#
#ここから下も変えない
#
#

D = ddd
ans = []
score = Array.new(D){Array.new()}
for i in 0...N
  for j in 0...D
    ans << j if list_copy[j].include?(i)
    score[j] << $AC_DATA[i] if list_copy[j].include?(i)
  end
end
bunsan = 0
heikin = $AC_DATA.sum / D
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
