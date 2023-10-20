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
  end
  return nil
end




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
    out_string = question_content
    s = ac_check(list[i], list[list_sort[c]])
    output_file[output_file_index+=1] = out_string
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
change_flag = 0
break_time = 0
question_time_copy = question_time
catch(:break_all) do
  while true
    ans = []
    for check_i in 0...N
      for check_j in 0...ddd
        ans << check_j if list[check_j].include?(check_i)
      end
    end
    out_string = "#c #{ans.join(" ")}"
    output_file[output_file_index+=1] = out_string
    while(list[list_sort[-1]].size == 1)
      list_sort.pop
      D -= 1
    end
    if question_time_copy == question_time
      break_time += 1
    else
      break_time = 0
    end
    question_time_copy = question_time
    break if D == 1

    if break_time >= (N/D) + D
      list_sort.pop
      D -= 1
    end
    break if D == 1

    which = rand(4)
    list_copy = list.map(&:dup)
    change_flag = 0
    if which <= 2
      # 交換
      next if list[list_sort[0]].size <= 1 || list[list_sort[-1]].size <= 1
      lower_side = list[list_sort[0]][rand(list[list_sort[0]].size)]
      upper_side = list[list_sort[-1]][rand(list[list_sort[-1]].size)]
      question_content = "#{1} #{1} #{lower_side} #{upper_side}"
      single_check = single_known_check(lower_side,upper_side,N)
      if single_check == nil && repeated_question[question_content] == nil
        throw :break_all if question_time == Q
        out_string = question_content
        s = ac_check([lower_side], [upper_side])
        output_file[output_file_index+=1] = out_string
        repeated_question = repeated_check(s, repeated_question, [lower_side], [upper_side])
        question_time += 1
        if s == "="
          $up_to_down_tree[lower_side][upper_side] = 0
        elsif s == "<"
          $up_to_down_tree[upper_side][lower_side] = 1
        elsif s == ">"
          $up_to_down_tree[lower_side][upper_side] = 1
        end
      else
        s = single_check
      end
      next if s != "<"

      list[list_sort[0]].delete(lower_side)
      list[list_sort[-1]].delete(upper_side)


      question_content = "#{list[list_sort[0]].size} #{list[list_sort[-1]].size} #{list[list_sort[0]].join(" ")} #{list[list_sort[-1]].join(" ")}"
      if repeated_question[question_content] == nil
        throw :break_all if question_time == Q
        out_string = question_content
        s = ac_check(list[list_sort[0]], list[list_sort[-1]])
        output_file[output_file_index+=1] = out_string
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
        out_string = question_content
        s = ac_check(list[list_sort[0]], list[list_sort[-1]])
        output_file[output_file_index+=1] = out_string
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
    change_flag = 1
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
          out_string = question_content
          s = ac_check(list[insert], list[list_sort[c]])
          output_file[output_file_index+=1] = out_string
          question_time += 1
          repeated_question = repeated_check(s,repeated_question,list[insert],list[list_sort[c]])
        else
          s = repeated_question[question_content]
        end
        if s == "=" && ddd == 2
          dis2flag = 1
          list_copy = list.map(&:dup)
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




if question_time != Q
  while(true)
    break if question_time == Q
    out_string = "1 1 0 1"
    s = 1
    output_file[output_file_index+=1] = out_string
    question_time += 1
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
