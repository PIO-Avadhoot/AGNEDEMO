       //*--------------------------------------------------------------------- *
       //* Programmers.IO - Lunch and Learn Sessions 2022-2023                  *
       //*--------------------------------------------------------------------- *
       Ctl-Opt Option (*NoDebugIo:*SrcStmt:*NounRef) DftActGrp(*No);

       Dcl-F Sales1;

       Dcl-DS SalesData;
          Customer;
          Address;
            Street         Overlay(Address);
            City           Overlay(Address:*Next);
            State          Overlay(Address:*Next);
          QuarterData;
            Q1             Overlay(QuarterData);
            Q2             Overlay(QuarterData:*Next);
            Q3             Overlay(QuarterData:*Next);
            Q4             Overlay(QuarterData:*Next);

          SalesForQtr      Overlay(QuarterData) Like(Q1) Dim(4);
       End-DS;

       Dcl-S Total Packed(9:2) Inz;
       Dcl-S Message Char(30)    Inz;


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

         Setll *Start Sales1;
         Read Sales1;
         Dow Not %EOF(Sales1);
             Dsply Customer;
             Dsply Address;
             Dsply Q1;
             Dsply Q2;
             Dsply Q3;
             Dsply Q4;
             Total = %Xfoot(Salesforqtr);
             Message = 'Total Sales = ' + %Char(Total);
             Dsply Message;
             Read Sales1;
         EndDo;

         *InLr = *On;

