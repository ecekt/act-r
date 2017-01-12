
(clear-all)

(define-model addition

(sgp :esc t :lf .05 :trace-detail low :SAVE-BUFFER-TRACE t)

(chunk-type count-order first second)
(chunk-type add-pair one1 ten1 one2 ten2 ten-ans one-ans carry1 count1 count2 carry-ans sum2 sum1 mustcount)

(add-dm
   (a ISA count-order first 0 second 1)
   (b ISA count-order first 1 second 2)
   (c ISA count-order first 2 second 3)
   (d ISA count-order first 3 second 4)
   (e ISA count-order first 4 second 5)
   (f ISA count-order first 5 second 6)
   (g ISA count-order first 6 second 7)
   (h ISA count-order first 7 second 8)
   (i ISA count-order first 8 second 9)
   (j ISA count-order first 9 second 10)
   (addcount-goal ISA add-pair ten1 3 one1 6 ten2 4 one2 7))

(p start-pair
  =goal>
    ISA add-pair
    one1 =num1
    one2 =num2
    one-ans nil
==>
  =goal>
    one-ans busy
    sum1 =num1
    count1 0
  +retrieval>
    ISA count-order
    first =num1
)

(P increment-count1
   =goal>
      ISA         add-pair
      one1 =num1
      one2 =num2
      sum1 =sum1
      one-ans busy
	 mustcount busy
      count1       =count1
   =retrieval>
      ISA         count-order
      first       =count1
      second      =newcount1
==>
   =goal>
      count1       =newcount1
	mustcount nil
   +retrieval>
      isa        count-order
      first      =sum1
)


(P increment-sum1
   =goal>
      ISA         add-pair
      one1 =num1
      one2 =num2
      sum1 =sum1
      one-ans busy
      count1       =count1
      - one2 =count1
	mustcount nil
   =retrieval>
      ISA         count-order
      first       =sum1
      second      =newsum1
==>
   =goal>
      sum1       =newsum1
	mustcount busy
   +retrieval>
      isa        count-order
      first      =count1
)

(P increment-sum1-withcarry
   =goal>
      ISA         add-pair
      one1 =num1
      one2 =num2
      sum1 10
      one-ans busy
      count1       =count1
      - one2 =count1
==>
   =goal>
      sum1       0

	carry1     1

)


(p write-sum1
  =goal>
      ISA         add-pair
      one1 =num1
      one2 =num2
sum1 =sum1
 count1 =count1
one2 =count1
 one-ans busy
==>
   =goal>
      one-ans         =sum1
	 ten-ans busy
	mustcount nil
	
)
(p start-pair2
  =goal>
    ISA add-pair
    ten1 =num1
    ten2 =num2
    ten-ans busy
    sum2 nil
==>
  =goal>
    sum2 =num1
    count2 0
    carry-ans 0
  +retrieval>
    ISA count-order
    first =num1
)

(P increment-count2
   =goal>
      ISA         add-pair
      ten1 =num1
      ten2 =num2
      sum2 =sum2
      ten-ans busy
      count2       =count2
	mustcount busy
  =retrieval>
      ISA         count-order
      first       =count2
      second      =newcount2
==>
   =goal>
      count2       =newcount2
	mustcount nil
   +retrieval>
      isa        count-order
      first      =sum2
)
(P increment-sum2
   =goal>
      ISA         add-pair
      ten1 =num1
      ten2 =num2
      sum2 =sum2
      ten-ans busy
      count2       =count2
      - ten2 =count2
	mustcount nil
   =retrieval>
      ISA         count-order
      first       =sum2
      second      =newsum2
==>
   =goal>
      sum2       =newsum2
	mustcount busy
   +retrieval>
      isa        count-order
      first      =count2
)

(P increment-sum2-withcarry
   =goal>
      ISA         add-pair
      ten1 =num1
      ten2 =num2
	 sum2 10
      ten-ans busy
      count2       =count2
      - ten2 =count2
==>
   =goal>
      sum2       0

	carry-ans     1
   +retrieval>
      isa        count-order
      first      =count2

)

(p transfer-carry-if-exists
 =goal>
    ISA add-pair
    sum2 =sum2
    ten-ans busy
count2 =count2
	ten2 =count2
     carry1 1
=retrieval>
     isa        count-order
     first      =sum2
	second 	=newsum2

==>
   =goal>
     sum2         =newsum2
	carry1 nil
	ten-ans nil
	
)
(p transfer-carry-if-exists-9
 =goal>
    ISA add-pair
    sum2 9
    ten-ans busy
count2 =count2
	ten2 =count2
     carry1 1
==>
   =goal>
     sum2         0
	carry1 nil
	carry-ans 1
	ten-ans nil
	
)


(goal-focus addcount-goal)
)

