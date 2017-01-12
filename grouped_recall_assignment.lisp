(defvar *response* nil)


(defun run-grouped-recall ()
(reset)
(setf *response* nil)

 (let*
	((result nil)
	(window (open-exp-window "Paired-Associate Experiment" :visible t)))
	
	(install-device window)
	
	(clear-exp-window)
	(add-text-to-exp-window :text "1" :x 110 :y 125)
    (add-text-to-exp-window :text "2" :x 120 :y 125)
    (add-text-to-exp-window :text "3" :x 130 :y 125)
	
	(proc-display)
    (run-full-time 5 :real-time t)
	
	(clear-exp-window)
	(add-text-to-exp-window :text "4" :x 110 :y 125)
    (add-text-to-exp-window :text "5" :x 120 :y 125)
    (add-text-to-exp-window :text "6" :x 130 :y 125)
	
	(proc-display)
    (run-full-time 5 :real-time t)
	
	(clear-exp-window)
	(add-text-to-exp-window :text "7" :x 110 :y 125)
    (add-text-to-exp-window :text "8" :x 120 :y 125)
    (add-text-to-exp-window :text "9" :x 130 :y 125)
	
	(proc-display)
    (run-full-time 5 :real-time t)
	
	(clear-exp-window)
	(add-text-to-exp-window :text "Recall" :x 125 :y 125)
	
	(proc-display)
    (run-full-time 25 :real-time t)
	
	(reverse *response*)
))

(defun record-response (value)
    (push value *response*))

(clear-all)
(define-model grouped

(sgp  :show-focus t :v t :act nil
     :declarative-num-finsts 15
     :declarative-finst-span 20
     :trace-detail high)


(chunk-type recall-list state group element list group-position)
(chunk-type group parent position id)
(chunk-type item name parent position)

(add-dm
   (list ISA group)
   (recall isa chunk)
   (first isa chunk) (second isa chunk)
   (third isa chunk) (fourth isa chunk)
   (goal ISA recall-list state	start list list))


(P find-unattended-letter
   =goal>
      ISA         recall-list 
      state       start
 ==>
   +visual-location>
      ISA         visual-location
	 screen-x lowest 
      :attended    nil
   =goal>
      state       find-location
)

(P attend-group
   =goal>
      ISA         recall-list 
      state       find-location
	list =list
	element nil
   =visual-location>
      ISA         visual-location
   
   ?visual>
      state       free
   
==>
   +visual>
      ISA         move-attention
      screen-pos  =visual-location
   =goal>
      state       attend
)
(P attend-letter
   =goal>
      ISA         recall-list 
      state       find-location
	list =list
	- element nil
   =visual-location>
      ISA         visual-location
   
   ?visual>
      state       free
   
==>
   +visual>
      ISA         move-attention
      screen-pos  =visual-location
   =goal>
      state       encode
)


(P encode-group-1
   =goal>
      ISA         recall-list 
      state       attend
	list =list
	element nil
	group-position nil
   =visual>
      ISA         text
      value       =letter
==>
   =goal>
      state       encode
	element first
	group group1
	group-position first
 =visual>

 +imaginal>
      isa         group
	 parent     =list
	 position first
	 id group1
)

(P encode-group-2
   =goal>
      ISA         recall-list 
      state       attend
	list =list
	element nil
	group-position first
   =visual>
      ISA         text
      value       =letter
==>
   =goal>
      state       encode
	element first
	group group2
	group-position second

 =visual>

 +imaginal>
      isa         group
	 parent     =list
	 position second
	 id group2
)

(P encode-group-3
   =goal>
      ISA         recall-list 
      state       attend
	list =list
	element nil
	group-position second
   =visual>
      ISA         text
      value       =letter

==>
   =goal>
      state       encode
	element first
	group group3
	group-position third

 =visual>

 +imaginal>
      isa         group
	 parent     =list
	 position third
	 id group3
)

(P encode-letter-1
   =goal>
      ISA         recall-list 
      state       encode
	element first
	group =grp
   =visual>
      ISA         text
      value       =letter
==>
   =goal>
      state       start
	element second

   +imaginal>
      isa         item
      name      =letter
	parent =grp
	position first
)
(P encode-letter-2
   =goal>
      ISA         recall-list 
      state       encode
	element second
	group =grp
   =visual>
      ISA         text
      value       =letter
==>
   =goal>
      state       start
	element third
   +imaginal>
      isa         item
      name      =letter
	parent =grp
	position second
)


(P encode-letter-3
   =goal>
      ISA         recall-list 
      state       encode
	element third
	group =grp
   =visual>
      ISA         text
      value       =letter

==>
   =goal>
      state       start
	element nil
  +imaginal>
      isa         item
      name      =letter
	parent =grp
	position third
)

(P respond
   =goal>
      ISA         recall-list 
      state       start
	group-position third
	 element third
 ==>
     =goal>
      state       recall
)

(p recall-first-group
   =goal>
      isa      recall-list
	  state		recall
      list     =list
   ?retrieval>
      buffer    empty
      state     free
    - state     error
==>
   =goal>
      group-position first
   +retrieval>
      isa      group
      parent   =list
      position first
)

(p start-recall-of-group
   =goal>
      isa      recall-list
	  state		recall
   =retrieval>
      isa      group
      id       =group
==>    
   =goal>
      group    =group 
      element  first
   +retrieval>
      isa      item
      :recently-retrieved nil
      parent   =group
      position first
)

(p harvest-first-item
   =goal>
      isa      recall-list
	  state		recall
      element   first
      group    =group
   =retrieval>
      isa      item
      name     =name
==>
   =goal>
      element  second
   +retrieval>
      isa      item
      parent   =group
      position second 
      :recently-retrieved nil
   !eval! (record-response =name)
)

(p harvest-second-item
   =goal>
      isa      recall-list
	  state	   recall
      element  second
      group    =group
   =retrieval>
      isa      item
      name     =name
==>
   =goal>
      element  third
   +retrieval>
      isa      item
      parent   =group
      position third
      :recently-retrieved nil
   !eval! (record-response =name)
)

(p harvest-third-item
   =goal>
      isa      recall-list
	  state	   recall
      element  third
      group    =group
   =retrieval>
      isa      item
      name     =name
==>
   =goal>
      element  fourth
   +retrieval>
      isa      item
      parent   =group
      position fourth
      :recently-retrieved nil
   !eval! (record-response =name)
)

(p second-group
   =goal>
      isa      recall-list
	  state	   recall
      group-position first
      list     =list
   
   ?retrieval>
       state    error
==>
   =goal>
      group-position second
   +retrieval>
      isa      group
      parent   =list
      position second
)

(p third-group
   =goal>
      isa      recall-list
	  state	   recall
      group-position second
      list     =list
   
   ?retrieval>
       state    error
   ==>
   =goal>
      group-position third
   +retrieval>
      isa      group
      parent   =list
      position third
)


(goal-focus goal)

(set-similarities 
 (first second -0.5)
 (second third -0.5)
 (first third -1))
)


