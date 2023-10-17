$stdout.sync = true
N, D, Q = gets.split.map(&:to_i)
ddd = D
question_time = 0
list = Array.new(D) { Array.new() }
repeated_question = Hash.new()

#トポロジカルソートっぽく1対1の既存質問を避ける
#重みもつける->=なら0で、
$up_to_down_tree = Array.new(N){Array.new(2){Array.new()}}
$down_to_up_tree = Array.new(N){Array.new(2){Array.new()}}
$dist = Array.new(N,0)
def up_to_down_known_check()

end
def down_to_up_known_check()

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

list_sort = [0]

for i in 1...D
  l = 0
  r = i

  while (r - l) > 0
    c = (l + r) / 2
    question_content = "#{list[i].size} #{list[list_sort[c]].size} #{list[i].join(" ")} #{list[list_sort[c]].join(" ")}"
    puts question_content
    s = gets.chomp
    repeated_question = repeated_check(s, repeated_question, list[i], list[list_sort[c]])
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


#ここまでで、D個のグループのsortが完了する




# 交換と譲渡を繰り返して良くしていく
dis2flag = 0
list_copy = [[]]
no_change_num = 0
change_flag = 0
roop_num = 0
catch(:break_all) do
  while true
    list_copy = list.map(&:dup)
    while(list[list_sort[D-1]].size == 1)
      D -= 1
    end
    break if D == 1

    lll = list_sort[0]
    rrr = list_sort[D-1]
    roop_num += 1
    roop_num = 0 if change_flag == 1
    change_flag = 0
    if roop_num >= 100
      lll = list_sort[rand(0...(D/2))]
      rrr = list_sort[rand((D/2)...D)]
    end
    # 多対多の交換
    lll_size = rand(1..(list[lll].size / 2))
    rrr_size = rand(1..50)
    if rrr_size == 1
      rrr_size = [lll_size - 3,1].max
    elsif rrr_size == 2
      rrr_size = lll_size + 3
    elsif rrr_size <= 4
      rrr_size = [lll_size - 2,1].max
    elsif rrr_size <= 6
      rrr_size = lll_size + 2
    elsif rrr_size <= 9
      rrr_size = [lll_size - 1,1].max
    elsif rrr_size <= 12
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
      puts question_content
      s = gets.chomp
      repeated_question = repeated_check(s, repeated_question, lll_delete_list, rrr_delete_list)
      question_time += 1
    else
      s = repeated_question[question_content]
    end
    next if s != "<"
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
    if s != "<"
      list = list_copy.map(&:dup)
      next
    end
    lll_delete_list.each { |del_l| list[rrr] << del_l }
    rrr_delete_list.each { |del_r| list[lll] << del_r }

    #確定
    change_flag = 1
    list_copy = list.map(&:dup)


    # 変更したグループを二分木への挿入の要領でsortさせる
    list_sort_first = list_sort[0]
    list_sort_end = list_sort[D - 1]
    [0, D - 1].each do |ii|
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
          repeated_question = repeated_check(s, repeated_question, list[insert], list[list_sort[c]])
        else
          s = repeated_question[question_content]
        end
        if s == "=" && D == 2
          dis2flag = 1
          list_copy = list.map(&:dup)
          throw :break_all
        elsif s == "="
          l = r = c + 1
        elsif s == ">"
          l = c + 1
        elsif s == "<"
          r = c
        end
      end

      if ii == 0
        list_sort_copy = list_sort.dup
        list_sort = []
        for j in 1...(D - 1)
          if j == l
            list_sort << insert
          end
          list_sort << list_sort_copy[j]
        end
        list_sort << insert if l == D - 1
      else
        list_sort_copy = list_sort.dup
        list_sort = []
        for j in 0...(D - 1)
          if j == l
            list_sort << insert
          end
          list_sort << list_sort_copy[j]
        end
        list_sort << insert if l == D - 1
      end
    end
  end
end



# 交換と譲渡を繰り返して良くしていく
#他がすべて1個で変えようがない場合、D=2で=になった場合が例外処理
if dis2flag == 1 || D == 1
  if question_time != Q
    while true
      break if question_time == Q
      puts "1 1 0 1"
      s = gets
      question_time += 1
    end
  end
end


ans = []
for i in 0...N
  for j in 0...ddd
    ans << j if list_copy[j].include?(i)
  end
end

puts ans.join(" ")
