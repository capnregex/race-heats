#!/usr/bin/env ruby

@boys = []
open "boys.txt", "r" do |f|
    f.each_line do |boy|
        @boys.push boy.chomp.split.first
    end
end

n = @boys.length
q = (0..n-1).to_a
bits = q.collect{|e| 1 << e}
raced = q.collect{|e| 1 << e}
race_count = q.collect{0}
done = false
heat = 1

while b1 = q.shift
    b2 = nil
    b3 = nil
    i = 0
    while (( b2 = q[i] ) and ( bits[b1] & raced[b2] > 0))
        i += 1
    end
    q.delete(b2)
    if b2
        race_count[b1] += 1
        race_count[b2] += 1
        raced[b1] |= bits[b2]
        raced[b2] |= bits[b1]
        i = 0
        while (( b3 = q[i] ) and (
               ( bits[b1] & raced[b3] > 0) or 
               ( bits[b2] & raced[b3] > 0)))
            i += 1
        end
        q.delete(b3)
        if b3
            race_count[b3] += 1
            raced[b1] |= bits[b3]
            raced[b2] |= bits[b3]
            raced[b3] |= bits[b1]
            raced[b3] |= bits[b2]
            print "%2d [  ]" % [heat]
            puts [b1,b2,b3].sort.collect{|b| "%15s [   ]" % [@boys[b]]}.join(' ')
            puts
            q.push(b1,b2,b3)
        else
            print "%2d [  ]" % [heat]
            puts [b1,b2].sort.collect{|b| "%15s [   ]" % [@boys[b]]}.join(' ')
            puts
            q.push(b1,b2)
        end
    end
    heat += 1
end

puts ""
puts "---------- results ----------"
race_count.each_with_index do |r,i|
    puts "%10s won: [   ] of %d = [    ]" % [@boys[i],r]
    puts
end
