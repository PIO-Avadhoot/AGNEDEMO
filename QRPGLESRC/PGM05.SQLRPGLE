       //*--------------------------------------------------------------------- *
       //* Programmers.IO - Lunch and Learn Sessions 2022-2023                  *
       //*--------------------------------------------------------------------- *
       Ctl-Opt Option (*NoDebugIo:*SrcStmt:*NounRef) DftActGrp(*No);

       Dcl-F Sales;

       Dcl-DS SalesData ExtName('SALES');
        SalesForQtr  Like(Q1) SamePos(Q1) Dim(4);
       End-DS;

       Dcl-S Total Packed(9:2) Inz;


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
        //Test comment for github
         Setll *Start Sales;
         Read Sales;
         Dow Not %EOF(Sales);
             Dsply Customer;
             Dsply Address;
             Dsply Q1;
             Dsply Q2;
             Dsply Q3;
             Dsply Q4;
             Total = %Xfoot(Salesforqtr);
             Dsply Total;
             Read Sales;
         EndDo;

         *InLr = *On;

