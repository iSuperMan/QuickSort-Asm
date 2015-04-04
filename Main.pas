var
    i:integer;
    ar:array[1..20] of integer=( 19,12,5,4,13,0,-7,11,8,17,2,-18,9,-1,16,15,3,6,10,14 );
    first:integer;
    last:integer;

    begin
        first:=1;
        last:=20;
        ASM
           LEA EDI, ar // EDI contain address of the first element of array 'ar'
           MOV EAX,0
           MOV EBX,0
           MOV ECX,0
           MOV EDX,0
           MOV ESI,0
           MOV AX, first // AX=first
           MOV BX, last  // BX=last
           CALL @quicksort // call function '@quicksort'
           JMP @_end  // go to flag '@_end'
           
           //description of the function '@quicksort'
           @quicksort:
             CMP AX, BX  //compare AX and BX
             JNB @end_qs //if AX>=BX then out from function( go to flag '@end_qs')
               CALL @partition //call function '@partition' that return the number of pivot in DX
               PUSH AX     //|
               PUSH BX     //| record to stack AX, BX, DX
               PUSH DX     //|
               DEC DX     // DX=DX-1
               MOV BX, DX // BX=DX
               CALL @quicksort //call function '@quicksort'
               POP DX      //|
               POP BX      //| read from stack AX, BX, DX
               POP AX      //|
               INC DX     // DX=DX+1
               MOV AX, DX // AX=DX
               CALL @quicksort //call function '@quicksort'
             @end_qs:
           RET // return from function
           
           //description of the function '@partition'
           @partition:
             MOV SI, AX        //| SI=AX
             DEC SI            //| SI=SI-1
             MOV CX, [EDI+EBX*2-2] // CX=ar[BX]
             MOV DX, AX // DX=AX
             DEC DX     //DX--
             
             //-------FOR--------------------
             @for:
               INC DX   //DX=DX+1
               CMP DX, BX  //compare DX and BX
               JNB @end_for     // if DX>=BX then finish cycle( go to '@end_for')
               CMP [EDI+EDX*2-2], CX // compare ar[DX] and CX
               JG @end_if // if ar[DX] > CX then go to '@end_if'
                 INC SI   // SI=SI+1
                 PUSH AX                //|
                 MOV AX, [EDI+ESI*2-2]  //|
                 XCHG AX, [EDI+EDX*2-2] //| ar[DX] <-> ar[SI]
                 XCHG AX, [EDI+ESI*2-2] //|
                 POP AX                 //|
               @end_if:
               JMP @for // go to begin of cycle ( go to flag '@for')
               @end_for: 
             //-------------END_FOR--------------------
             
               PUSH AX                //|
               MOV AX, [EDI+ESI*2]    //|
               XCHG AX, [EDI+EBX*2-2] //| ar[SI+1] <-> ar[BX]
               XCHG AX, [EDI+ESI*2]   //|
               POP AX                 //|
               MOV DX, SI      //| DX=SI
               INC DX          //| DX=DX+1 - number of pivot
             @end_p:
           RET //return from function
           
           @_end:
           
        END;
        for i:=first to last
        do  begin
            write(ar[i]);
            write(', ');
            end;
end.
