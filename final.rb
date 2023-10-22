$stdout.sync = true
N, D, Q = gets.split.map(&:to_i)
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


#Dが3以下の時のコード
if D <= 3
list_copy = [[]]
roop_num = 0
change_flag = 0
while true
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
  which_rand = 10
  # 多対多の交換
  if D == 2
    which_rand = 13
  elsif D == 3
    which_rand = 6
  end
  if which <= which_rand || roop_num> N * 3
    next if list[lll].size == 1 || list[rrr].size == 1
    lr_rand = rand(2)
    if lr_rand == 0
      lll_size, rrr_size = 2, 1
    elsif lr_rand == 1
      lll_size, rrr_size = 2, 2
    end
    lll_size = rrr_size = 1 if roop_num <= N * 3
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
        puts question_content
        s = gets.chomp
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
        puts question_content
        s = gets.chomp
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
        puts question_content
        s = gets.chomp
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
        puts question_content
        s = gets.chomp
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
    change_flag = 1
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




#Dが4以上のときのコード
else
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
  list_copy = [[]]
  change_flag = 0
  break_time = 0
  list_sort2 = [[]]
  break_time_limit = (N/D)
  catch(:break_all) do
    while true
      list_sort = list_sort2.dup if change_flag == 0 && break_time > break_time_limit
      #一番重いグループの要素が一つのとき
      while(list[list_sort[D-1]].size == 1)
        D -= 1
        list_sort.pop
      end
      break if D == 1


      if change_flag == 0
        break_time += 1
      else
        break_time = 0
      end


      if break_time >= break_time_limit
        list_sort2 = list_sort.dup
        lr_rand = rand(2)
        list_sort_change_index = [break_time/break_time_limit % (D-1),1].max
        list_sort3 = list_sort.dup
        list_sort = []
        if lr_rand == 0
          list_sort[0] = list_sort3[list_sort_change_index]
          for lr_roop in 0...D
            next if lr_roop == list_sort_change_index
            list_sort << list_sort3[lr_roop]
          end
        elsif lr_rand == 1
          list_sort_change_index = D - 1 - list_sort_change_index
          for lr_roop in 0...D
            next if lr_roop == list_sort_change_index
            list_sort << list_sort3[lr_roop]
          end
          list_sort << list_sort3[list_sort_change_index]
        end
      end
      throw :break_all if break_time >= N*10 || (Q-question_time) < 10
      which = rand(20)
      list_copy = list.map(&:dup)
      change_flag = 0
      if which <= 5
        # 交換
        next if list[list_sort[0]].size <= 1 || list[list_sort[D-1]].size <= 1
        lower_side = list[list_sort[0]][rand(list[list_sort[0]].size)]
        upper_side = list[list_sort[D-1]][rand(list[list_sort[D-1]].size)]
        question_content = "#{1} #{1} #{lower_side} #{upper_side}"
        single_check = single_known_check(lower_side,upper_side,N)
        if single_check == nil
          throw :break_all if question_time == Q
          puts question_content
          s = gets.chomp
          repeated_question = repeated_check(s, repeated_question, [lower_side], [upper_side])
          question_time += 1
          if s == "="
            $up_to_down_tree[lower_side][upper_side] = 0
            $up_to_down_tree[upper_side][lower_side] = 0
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
        list[list_sort[D-1]].delete(upper_side)


        question_content = "#{list[list_sort[0]].size} #{list[list_sort[D-1]].size} #{list[list_sort[0]].join(" ")} #{list[list_sort[D-1]].join(" ")}"
        if repeated_question[question_content] == nil
          throw :break_all if question_time == Q
          puts question_content
          s = gets.chomp
          question_time += 1
          repeated_question = repeated_check(s,repeated_question,list[list_sort[0]],list[list_sort[D-1]])
        else
          s = repeated_question[question_content]
        end
        if s != "<"
          list = list_copy.map(&:dup)
          next
        end

        list[list_sort[0]] << upper_side
        list[list_sort[D-1]] << lower_side
      else
        # 譲渡
        upper_side = list[list_sort[D-1]][rand(list[list_sort[D-1]].size)]
        list[list_sort[D-1]].delete(upper_side)
        # 失敗check
        question_content = "#{list[list_sort[0]].size} #{list[list_sort[D-1]].size} #{list[list_sort[0]].join(" ")} #{list[list_sort[D-1]].join(" ")}"
        if repeated_question[question_content] == nil
          throw :break_all if question_time == Q
          puts question_content
          s = gets.chomp
          question_time += 1
          repeated_question = repeated_check(s,repeated_question,list[list_sort[0]],list[list_sort[D-1]])
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
            puts question_content
            s = gets.chomp
            question_time += 1
            repeated_question = repeated_check(s,repeated_question,list[insert],list[list_sort[c]])
          else
            s = repeated_question[question_content]
          end
          if s == "="
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
  if (Q != question_time)
  #ここからはrandom
  list = list_copy.map(&:dup)
  roop_num = 0
  change_flag = 0
  while true
    list_copy = list.map(&:dup)
    lll = list_sort[rand(D)]
    rrr = list_sort[rand(D)]
    lll,rrr = list_sort[0],list_sort[D-1] if break_time <= 50
    next if lll == rrr

    roop_num += 1 if change_flag == 0
    if change_flag == 1
      roop_num = 0
      change_flag = 0
      break_time = 100
    end
    if roop_num >= 50
      break_time = 100
    end

    which = rand(5)
    # 多対多の交換
    if which <= 3 || roop_num>N
      next if list[lll].size == 1 || list[rrr].size == 1
      lr_rand = rand(2)
      if lr_rand == 0
        lll_size, rrr_size = 2, 1
      elsif lr_rand == 1
        lll_size, rrr_size = 2, 2
      end
      lll_size = rrr_size = 1 if roop_num <= N
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
          puts question_content
          s = gets.chomp
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
          puts question_content
          s = gets.chomp
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
          puts question_content
          s = gets.chomp
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
          puts question_content
          s = gets.chomp
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
      change_flag = 1
      list[lll] << upper_side
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
end
