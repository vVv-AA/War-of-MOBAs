range =
   function (i, to, inc)
        if i == nil then return end -- range(--[[ no args ]]) -> return "nothing" to fail the loop in the caller

       if not to then
           to = i 
           i  = to == 0 and 0 or (to > 0 and 1 or -1) 
       end 

       -- we don't have to do the to == 0 check
       -- 0 -> 0 with any inc would never iterate
       inc = inc or (i < to and 1 or -1) 

       -- step back (once) before we start
       i = i - inc 

       return function () if i == to then return nil end i = i + inc return i, i end 
   end 
