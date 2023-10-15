$AC_DATA = %w(42789 26023 52131 52694 41816 1734 25720 142117 34123 18227 74649 4126 62911 83007 175627 2819 232807 210456 70234 184590 86146 26456 48810 33189 180024 134174 45597 59565 56446 124428 75874)
$AC_DATA = $AC_DATA.map &:to_i
N, D, Q = %w(31 2 128).map &:to_i
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
#2. out_string =  -> out_string = に変える

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
output_file.each{|dd|file.puts dd}
file.close
end


$stdout.sync = true
ddd = D
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
    out_string =  "#{list[i].size} #{list[list_sort[c]].size} #{list[i].join(" ")} #{list[list_sort[c]].join(" ")}"
    s = ac_check(list[i], list[list_sort[c]])
    output_file[output_file_index+=1] = out_string
    ans = []
    for check_i in 0...N
      for check_j in 0...ddd
        ans << check_j if list[check_j].include?(check_i)
      end
    end
    out_string = "#c #{ans.join(" ")}"
    output_file[output_file_index+=1] = out_string
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



    which = rand(3)
    list_copy = list.map(&:dup)
    ans = []
    for check_i in 0...N
      for check_j in 0...ddd
        ans << check_j if list[check_j].include?(check_i)
      end
    end
    out_string = "#c #{ans.join(" ")}"
    output_file[output_file_index+=1] = out_string
    if which <= 1
      # 交換
      lower_side = list[list_sort[0]][rand(list[list_sort[0]].size)]
      upper_side = list[list_sort[-1]][rand(list[list_sort[-1]].size)]
      list[list_sort[0]].delete(lower_side)
      list[list_sort[-1]].delete(upper_side)
      list[list_sort[0]] << upper_side
      list[list_sort[-1]] << lower_side
    else
      # 譲渡
      upper_side = list[list_sort[-1]][rand(list[list_sort[-1]].size)]
      list[list_sort[-1]].delete(upper_side)
      # 失敗check
      throw :break_all if question_time == Q
      out_string =  "#{list[list_sort[0]].size} #{list[list_sort[-1]].size} #{list[list_sort[0]].join(" ")} #{list[list_sort[-1]].join(" ")}"
      s = ac_check(list[list_sort[0]], list[list_sort[-1]])
      output_file[output_file_index+=1] = out_string
      question_time += 1
      if s != "<"
        list = list_copy.map(&:dup)
        next
      end
      list[list_sort[0]] << upper_side
    end

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
        out_string =  "#{list[insert].size} #{list[list_sort[c]].size} #{list[insert].join(" ")} #{list[list_sort[c]].join(" ")}"
        s = ac_check(list[insert],list[list_sort[c]])
        output_file[output_file_index+=1] = out_string
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
        out_string =  "#{list[list_sort[1]].size} #{list[list_sort[D-1]].size} #{list[list_sort[1]].join(" ")} #{list[list_sort[D-1]].join(" ")}"
        s = ac_check(list[list_sort[1]],list[list_sort[D-1]])
        output_file[output_file_index+=1] = out_string

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

list_copy = list.map(&:dup) if dis2flag == 1
if question_time != Q
  while(true)
    break if question_time == Q
    out_string =  "1 1 0 1"
    s = 1
    output_file[output_file_index+=1] = out_string
    question_time += 1
  end
end

ans = []
for check_i in 0...N
  for check_j in 0...ddd
    ans << check_j if list[check_j].include?(check_i)
  end
end

out_string = ans.join(" ")
output_file[output_file_index += 1] = out_string
file = File.open("output.txt", "w")
output_file.each{|dd|file.puts dd}
file.close
