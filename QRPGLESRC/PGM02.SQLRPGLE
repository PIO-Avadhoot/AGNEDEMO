       //*--------------------------------------------------------------------- *
       //* Programmers.IO - Lunch and Learn Sessions 2022-2023                  *
       //*--------------------------------------------------------------------- *
       Ctl-Opt Option (*NoDebugIo:*SrcStmt:*NounRef) DftActGrp(*No);

       Dcl-F Sales;

       Dcl-DS SalesData;
          Q1;
          Q2;
          Q3;
          Q4;

        SalesForQtr  Like(Q1) Pos(1) Dim(4);
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

         Setll *Start Sales;
         Read Sales;
         Dow Not %EOF(Sales);
             Dsply Customer;
             Dsply Address;
             Dsply SalesForQtr(1);
             Dsply SalesForQtr(2);
             Dsply SalesForQtr(3);
             Dsply SalesForQtr(4);
             Read Sales;
         EndDo;

         *InLr = *On;

