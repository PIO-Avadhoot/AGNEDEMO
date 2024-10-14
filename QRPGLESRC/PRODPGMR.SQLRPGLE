       //*--------------------------------------------------------------------- *
       //* Programmers.IO - Lunch and Learn Sessions 2022-2023                  *
       //*--------------------------------------------------------------------- *
       Ctl-Opt Option (*NoDebugIo:*SrcStmt:*NounRef) DftActGrp(*No);


      //test comment
       //Externally described data structure
       Dcl-F  Product;
       Dcl-F PRODSUBF  WorkStn Indds(IndicatorDs) Infds(Infds)
                               Sfile(PRDsfldtl:Rrn#);

       //program status data structure
       Dcl-ds Pgm_sDs PSDS;
         JobName  Char(10)   pos(244);
         UserName Char(10)   pos(254);
         Job#     zoned(6:0) pos(264);
         PgmName  Char(10)   pos(324);
       End-ds;

       //File information data structure
       Dcl-Ds Infds;
         KeyPressed  Char(1) Pos(369);
       End-Ds;

       //Indicator data structure
       Dcl-ds IndicatorDs;
         Exit          Ind pos(03);
         Refresh       Ind pos(05);
         Hide_Show     Ind pos(11);
         Cancel        Ind pos(12);
         SortID        Ind Pos(07);
         SortName      Ind Pos(08);
         SflNxtChg     Ind Pos(30);
         Control       Pos(31);
           SflDsp      Ind Overlay(Control);
           SflDspCtl   Ind Overlay(Control:*Next);
           SflClr      Ind Overlay(Control:*Next);
         SflEnd        Ind pos(34) Inz('1');
         SortIDHdr     Ind pos(91) Inz('0');
         SortNameHdr   Ind pos(92) Inz('0');
       End-ds;

       Dcl-ds Product1Ds Qualified Dim(9999) Inz;
          Prod_ID   Zoned(5);
          Prod_Name Char(10);
       End-Ds;

       //Externally described data structure
       Dcl-Ds ProdSubfDs  LikeRec(PRDSFLDTL: *All) Dim(9999);

       //StandAlone Variable
       Dcl-S Rrn#       Packed(5:0)   Inz;
       Dcl-S w_Count    Packed(5:0)   Inz;
       Dcl-S w_MaxRec   Packed(4:0)   Inz(9999);

       //*----------------------------------------------------------------- *//
       //*                   Mainline code (Begin)                          *//
       //*----------------------------------------------------------------- *//
       Exec sql
         Set option commit = *none,
                    naming = *sys,
                 dynusrprf = *user,
                 closqlcsr = *endmod;

         Clear_SubFile();
         Load_Array();

         Dow (Not Exit) And (Not Cancel);
            Load_Subfile();
            Display_Subfile();
            Select;
            When Exit Or Cancel;
              End_Program();
            When SortId;
              Sort_By_ID();
            When SortName;
              Sort_By_Name();
            EndSl;
            Clear_Subfile();
         EndDo;
       //*----------------------------------------------------------------- *//
       //*                   Clear Subfile                                  *//
       //*----------------------------------------------------------------- *//
       Dcl-Proc Clear_Subfile;

         Clear PRDSFLDTL;

         Rrn# = 0;

         SflClr = *On;

         Write PRDsflctl;

         SflClr = *Off;

       End-Proc;
       //*----------------------------------------------------------------- *//
       //*Array Load                                                        *//
       //*----------------------------------------------------------------- *//
       Dcl-Proc Load_Array;

          Exec Sql
             Declare ProductCsr Cursor For
             Select * From Product;

          Exec Sql
             Open ProductCsr;

          Exec Sql
             Fetch Next From ProductCsr For
             :w_MaxRec rows Into :Product1Ds;

          Exec Sql
             Get Diagnostics :w_Count = Row_count;

          Exec Sql
             Close ProductCsr;

                    ProdSubfDs = Product1Ds;

          Message = 'Subfile loaded with product data';

       End-Proc;
       //*----------------------------------------------------------------- *//
       //*Subfile Load                                                      *//
       //*----------------------------------------------------------------- *//
       Dcl-Proc Load_SubFile;

          For RRN# = 1 to w_Count;
             Write PrdSflDtl ProdSubfDs(RRN#);
          EndFor;

       End-Proc;
       //*----------------------------------------------------------------- *//
       //*Sfl_Display        Display Subfile (Begin)                        *//
       //*----------------------------------------------------------------- *//
       Dcl-Proc Display_Subfile;

           sflDsp     = *On;

           sflDspctl  = *On;

           If Rrn# = 0 ;
             sfldsp  = *Off;
           EndIf;

           Write Header;

           Write Footer;

           Exfmt Prdsflctl;

       End-Proc;
       //*----------------------------------------------------------------- *//
       //* Sort Subfile by ID                                               *//
       //*----------------------------------------------------------------- *//
       Dcl-Proc Sort_By_ID;

          SortA %SubArr(ProdSubfDs(*).PRNUM#: 1: RRN#-1);

          Message = 'Subfile data sorted by product ID';

          SortIDHdr   = *On;

          SortNameHdr = *Off;

       End-Proc;
       //*----------------------------------------------------------------- *//
       //* Sort Subfile by Name                                             *//
       //*----------------------------------------------------------------- *//
       Dcl-Proc Sort_By_Name;

          SortA %SubArr(ProdSubfDs(*).PRNAME: 1: RRN#-1);

          Message = 'Subfile data sorted by product name';

          SortNameHdr = *On;

          SortIdHdr   = *Off;

       End-Proc;
       //*----------------------------------------------------------------- *//
       //*  Sr_Endpgm        End of program (Begin)                         *//
       //*----------------------------------------------------------------- *//
       Dcl-Proc End_Program;
         *Inlr = *On;
       End-Proc;

