info: BestBot, Best from the Web 
        
main: 
        // select a random direction and distance to move
        rand [dir], 4
        mov r0, 0             // shouldn't matter, but it does!
        
loop:
        // see if we're over a collection point and
        // release some energy
        release 1
        jns notEnufEnergy
        energy r5 
        sub r5, 4500          // release down to 4500
        release r5
        
notEnufEnergy:
        // move me
        travel [dir]
        js loop2              // bumped into another org or the wall
        charge [dir], 200     // charge people - 
        rand [dir], 4
        jmp notEnufEnergy2
        
dir:
        data {2}              // the direction
        
loop2:
        // check if I'm top of food and eat if so
        sense r5              // notable square?
        jns notEnufEnergy2    // nothing to see here. move along.
        mod r5, 16            // mod it by 16
        mov r1, 1
        shl r1, r5            // the joy of bitsets
        test r1, r7           // is it poisonous?
        jne n2                // test returns not equal if they have something in com
        mov r9, 0             // Take a chksum
        cksum r9, 3600
        eat
        mov r10, 0
        cksum r10, 3600       // take another checksum
        cmp r10, r9           // if they're equal, we're fine
        je n2                 // otherwise, we're poisoned!
        mov r1, 1             // r1 = 1
        shl r1, r5            // shift left by food type
        or r7, r1             // store it in the poison bitvec
        // see if we're over a collection point and
        // release some energy
        
n2:
        release 1
        jns notEnufEnergy2
        
        energy r5 
        sub r5, 4500
        release r5
        
notEnufEnergy2:
        // move me
        travel [dir]
        js loop2               // bumped into another org or the wall
        charge [dir], 200 
        poke [dir], 7 
        rand [dir], 4
        jmp notEnufEnergy3
                
loop3:  // another copy of the loop
        // alternate between the two. this reduces the harm of 
        // data corruption
        // interestingly, more than 2 and the score drops again
        
        // check if I'm top of food and eat if so
        sense r5
        jns notEnufEnergy3
        mod r5, 16
        mov r1, 1
        shl r1, r5
        test r1, r7             // is it poisonous?
        jne n3
        mov r9, 0
        cksum r9, 3600
        eat
        mov r10, 0
        cksum r10, 3600
        cmp r10, r9
        je n3
        //call poisoned
        
        mov r1, 1               // r1 = 1
        shl r1, r5              // shift left by food type
        or r7, r1               // store it in the poison bitvec
        // see if we're over a collection point and
        // release some energy
        
n3:
        release 1
        jns notEnufEnergy3
        
        energy r5 
        sub r5, 4500
        release r5
        
notEnufEnergy3:
        // move me
        travel [dir]
        js loop3                 // bumped into another org or the wall
        charge [dir], 200
        rand[dir], 4
        jmp notEnufEnergy2
        
        // after this point the rest of the memory is filled with jmp instructions
        // returning to two copies of the main loop - very useful in case we 
        // jump to a random area due to mutation, definitely increases the score

