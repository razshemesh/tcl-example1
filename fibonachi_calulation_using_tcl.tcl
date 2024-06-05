



# create an empty stack
set stack {}

# define a procedure to push an element onto the stack
proc push {a} {
  lappend stack $a
}


 : 
# define a procedure to pop the top element from the stack
proc pop {stack} {
  set top [lindex $stack end]
  set stack [lrange $stack 0 end-1]
  return $top
}


#section 2 :
# define a procedure to calculate the modified Fibonacci number
proc fiboC {n C} {
  set a1 1
  set a2 2
  set a $a2
  for {set i 3} {$i <= $n} {incr i} {
    set a3 [expr {$a + $C * $a2}]
    set a $a2
    set a2 $a3
  }
  if {$n == 1} {
    return $a1
  } elseif {$n == 2} {
    return $a2
  } else {
    return $a
  }
}


#section 3 :
# define a procedure to print the n x n matrix
proc matrix {n} {
  for {set i 1} {$i <= $n} {incr i} {
    for {set j 1} {$j <= $n} {incr j} {
      set value [expr {$i * $j}]
      puts $value
    }
    puts ""
  }
}


#section 4 :
# define a procedure to convert a list of lists to an array
proc my_array_set {arr l} {
  set i 0
  foreach sublist $l {
    set j 0
    foreach element $sublist {
      set varname "${arr}($i,$j)"
      upvar 1 $varname var
      set var $element
      incr j
    }
    incr i
  }
}





#1
#Returns a collection of all the outputs driven by the ref_clk.
all_fanout -from [get_ports ref_clk]

#2
#Returns all the registers' output pins that are clocked by test_clk.
all_registers -output_pins -clock [get_clocks test_clk]

#3
#Returns all instances under the FIR_filter_1 module.
all_instances [get_design FIR_filter_1]

#4
#Reports the value of the 'property' attribute of the 'rst' port.
report_property [ get_ports rst ]

#5
#Returns the fourth element in the collection of all ports.
index_collection [get_ports *] 4

#6
#Returns all cells in the current design.
get_cells *

#7
#Returns all hierarchical cells in the current design.
get_cells * -hierarchical

#8
#Returns the cell with the specified hierarchical path.
get_cells AO1/add_94_37_I2/g703

#9
#Returns the value of the 'area' property of the specified cell.
get_property [get_cells AO1/add_94_37_I2/g703] area

#10
#Loops through all hierarchical cells with more than three pins and outputs their name, pin count, and reference cell name.
foreach_in_collection inst_C [filter_collection [get_cells * -hierarchical] {pin_count > 3 && is_hierarchical == true}] {
 set name [ get_property $inst_C name ]
 set count [ get_property $inst_C pin_count ]
 set cell [ get_property $inst_C ref_lib_cell_name ]
 puts "$name $count $cell"
}

#11
#Returns the value of the 'period' attribute of the 'ref_clk' clock.
get_property [ get_clocks ref_clk ] period

#12
#Loops through all pins in the DFF library that are input pins and are clocked pins and outputs their hierarchical name.
foreach_in_collection pin_C [filter_collection [ get_lib_pins DFF*/* ] {direction == in && is_clock == true}] {
 puts [ get_property $pin_C hierarchical_name ]
}





#1
# Find all ports
set ports [get_ports -hier *]

#2
# Find all nets which are connected to ports
set nets [get_nets -of_objects [get_ports -hier *]]

#3
# Find all cells which have U in their instance name
set cells [get_cells -hier *U*]

#4
# Find all cells which have OR2 in their base_name
set cells [get_cells -hier OR2*]

#5
# Find all ports which are in layer M13
set ports [get_ports -of_objects [get_layers M13]]





#section 1 :
#we need to calculate the number of wires we go through in this placement first , then the length is number of wires in units.
#since there are no direct wire between each pair of A cells , but each A cell is directly connected to each B cell, then when we go from one A cell to the next we have to go through a wire to B cell then another wire to the next A cell (total 2 wires from one A cell to the next), same goes for going one B cell to the next cell. 
#going from in to every A cell we need 1 wire , and from each B cell to out we need 1 wire. 

#the provided placement is :
#in<->A1<->A2<->A3<->A4<->A5<->B1<->B2<->B3<->B4<->B5<->C1<->out.
#in conclusion we have 4 direct switches between A cells (8 wires) , 4 direct switches between B cells (8 wires), one switch from A5 to B1 (1 wire), one switch from in to A1 (1 wire) and one switch from B5 to C1 (1 wire) and 1 wire from C1 to out. 
#a total of 20 wires , so the total wire length needed for this placement is 20 units.

#section 2 :
#we can put a B cell between each pair of A cells since we have a direct wire between each A cell and each B cell, thus minimizing the number of switches from A cells to B cells (in the previous placement we go to each B cell twice , once when going from one A cell to the next and once when we go to B cells in the placement), same for putting an A cells between each pair of B cells, now minimizing the number of times we go through A cells. 
#the new placement is : 
#in<->A1<->B2<->A2<->B2<->A3<->B3<->A4<->B4<->A5<->B5<->C1<->out.
#the total number of wires is 12 wires (1 wire between each pair of cells, and 1 wire from in to A1 and 1 wire from C1 to out), and the total wire length is 12 units.


#section 3 :
#for the optimal solution we build the next algorithm : 
#from in we go to a random A cell, then from that A cell we go to a random B cell , each time we visit a cell its marked so as to not go back to the same cell more than one , and we continue switching from unmarked A cells to unmarked B cells , untill we have only one last unmarked B cell then we move to C1 and to out.
#execution time for the algorithm is n (n being the number of cells we have, in this case its 11), since we fo through each cell only once , so the solution is polynomal.


#section 4 : 
#since the algorithm we built in section 3 is a general algorithm, and it runs in optimal n time, then the answer doesnt change for any n.


