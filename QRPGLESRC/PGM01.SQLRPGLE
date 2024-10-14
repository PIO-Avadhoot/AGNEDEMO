       //*--------------------------------------------------------------------- *
       //* Programmers.IO - Lunch and Learn Sessions 2022-2023                  *
       //*--------------------------------------------------------------------- *
       Ctl-Opt Option (*NoDebugIo:*SrcStmt:*NounRef) DftActGrp(*No);
       //Data Structure Declarations
       Dcl-DS Messages;
          *n Char(20) Inz('Invalid Item Code');
          *n Char(20) Inz('Invalid Customer');
          *n Char(20) Inz('Item Code required');
          *n Char(20) Inz('Invalid store');

          Msg Char(20) Dim(4) Pos(1);  //Array for DS
       End-DS;

       //---------------------------------------------------------------------
       //  Main Line
       //---------------------------------------------------------------------
       Exec sql
          Set option
             Naming    = *Sys,
             Commit    = *None,
             UsrPrf    = *User,
             DynUsrPrf = *User,
             CloSqlCsr = *EndMod;
         //Displaying messages
         //19-06-2024
         Dsply Msg(1);
         Dsply Msg(2);
         Dsply Msg(3);
         Dsply Msg(4);

         *InLr = *On;
