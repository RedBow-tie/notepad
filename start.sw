
#define VIEW_MODE 0   //read only
extern form x_sql () load ( "sql" )


char Init_db [] 100 =
"create table line (nr int)"
"create table sections (sec text, sort int primarykey)"
"create table doc (document text, first_line text, sec int, filename text, primary key (sec,document) )"
"create table doc_text (id int primarykey, doc blob )"
"insert into line values (20)"
end

mtext Welcome
{\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1053{\fonttbl{\f0\fnil\fcharset0 Calibri;}}
{\colortbl ;\red0\green0\blue255;}
{\*\generator Riched20 10.0.19041}\viewkind4\uc1 
\pard\sl240\slmult1\qc\cf1\f0\fs32\lang29 Welcome\par
Hope you like it!\par

\pard\sa200\sl240\slmult1\fs28\par
\pard\sa200\sl276\slmult1\cf0\fs22\par
}
end


char Label [8] 20 = 
""
"Format 1"
"Format 2"
"Format 3"
"Format 4"
"Format 5"
end

char Tem_label [8] 20 = 
""
"Template 1"
"Template 2"
"Template 3"
"Template 4"
"Template 5"
"Template 6"
end

text Template [10]
int Save

struct tablerow
							// EM_INSERTTABLE wparam is a (TABLEROWPARMS *)
	char	cbRow			// Count of bytes in this structure
	char	cbCell 		// Count of bytes in TABLECELLPARMS
	char	cCell			// Count of cells
	char	cRow			// Count of rows
	int 	dxCellMargin	// Cell left/right margin (\trgaph)
	int 	dxIndent		// Row left (right if fRTL indent (similar to \trleft)
	int 	dyHeight		// Row height (\trrh)
    int     flag
	//~ DWORD	nAlignment:3;	// Row alignment (like PARAFORMAT::bAlignment, \trql, trqr, \trqc)
	//~ DWORD	fRTL:1; 		// Display cells in RTL order (\rtlrow)
	//~ DWORD	fKeep:1;		// Keep row together (\trkeep}
	//~ DWORD	fKeepFollow:1;	// Keep row on same page as following row (\trkeepfollow)
	//~ DWORD	fWrap:1;		// Wrap text to right/left (depending on bAlignment)
	//~ DWORD	fIdentCells:1;	// lparam points at single struct valid for all cells
	int 	cpStartRow		// cp where to insert table (-1 for selection cp)
	//	(can be used for either TRD by EM_GETTABLEPARMS)
	char	bTableLevel	// Table nesting level (EM_GETTABLEPARMS only)
	char	iCell			// Index of cell to insert/delete (EM_SETTABLEPARMS only)
end

def struct _paraformat 
    int _size 
    int mask
    short wNumbering
    short wEffects
    int dxStartIndent
    int dxRightIndent
    int dxOffset
    short wAlignment
    short cTabCount
    int rgxTabs [32]
end

struct _paraformat paraformat


int Doc = -1
int Sec = -1
int Doc_oid = -1
int Sec_oid = -1

query sql, sql2

menu menu1
    menu_item ( M1, "File", m_submenu )
    menu_item ( M_LOAD, "Load file" )
    menu_item ( M_SAVE, "Save file" )
    menu_item ( M_SQL, "SQL", m_separator )
    menu_item ( M_EXIT, "Exit", m_last | m_separator )

    menu_item ( MD, "Section", m_submenu )
    menu_item ( MNS, "New" )
    menu_item ( MDS, "Delete", m_last )

    menu_item ( MD, "Document", m_submenu )
    menu_item ( MND, "New" )
    menu_item ( MDD, "Delete", m_last )
end

struct comp_color
    int txt
    int bg
    int effect
end

struct charformat 
    int _size
    int mask
    int effects
    int yheight
    int yoffset
    int _color
    char charSet
    char family
    char facename 34
end

def struct charfmt22 
	int		_size
	int		mask
	int		effects
	int		height
	int		offset			// > 0 for superscript, < 0 for subscript 
	int	    _color
	char	charSet
	char	pitch
	char	facename 32
	short	weight			// Font weight (LOGFONT value)		
	short	spacing			// Amount to space between letters	
    short  slask
	int	    bgcolor		// Background color 				
	int		lcid				// Locale ID						
    int		cookie	 		// Client cookie opaque to RichEdit
	short	style 			// Style handle 					
    short	kerning			// Twip size above which to kern char pair
	char	underlineyype 	// Underline type					
	char	animation 		// Animated text like marching ants 
	char	revauthor 		// Revision author index			
	char	underlinecolor	// Underline color
end
 
struct charfmt22 charfmt2 [7]


int C  

mtext Init_rich  //this from init.rtf
{\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1053{\fonttbl{\f0\fnil\fcharset0 Calibri;}}
{\*\generator Riched20 10.0.19041}\viewkind4\uc1 
\pard\sl240\slmult1\f0\fs22\lang29\par
}
end

/*  old
{\rtf1\ansi\ansicpg1252\deff0\nouicompat\deflang1053{\fonttbl{\f0\froman\fprq2\fcharset0 Times New Roman;}}
{\colortbl ;\red0\green0\blue0;}
{\*\generator Riched20 10.0.19041}\viewkind4\uc1 
\pard\cf1\kerning1\f0\fs20\lang1033\par
}
*/


form ch_lang ()

int Pos [2]

    layout "Change language" RESIZE sysmenu 

 a          ab      b                      
 a          a                     
 a          a                     
 a          a                     
 a          a                     
 a          a                     
 
end
pre
        if ( ask ( "Save settings ? ", 0x23 ) )
    end
end

field
a: RB "Swedish"
a: RB "English"
a: RB "Spanish"
a: RB "French"
a: RB "German"
a: RB "Italian"
b: BT "Ok"
end

form name ( char label 50, int cmd ), DEFAULT_CR
    layout  sysmenu

 a     aa                aa     a

end
pre
    .title ( "Create [#label]" )
end

field
a: rtext "Label"
a: V_C edit
a: IDOK Bt "Ok"
    select
        int i, z

        if ( trim ( .V_C ) == "" )
            mess ( "Please enter a [#label] name" )
            .focus ( V_C )
            return 0
        else
            switch ( cmd )
                case 0
                    sql.begin ()
                    sql.insert ( "sections values ( [.V_C],(select nr from line) )" )
                    i = _LAST_OID
                    sql.update ( "line set nr=nr+10" )            
                    sql.COMMIT ()
                    z = .additem ( V_Sec, .V_C )
                    .change_oid ( V_Sec, z, i )
                    break
                case 1
                    if ( Sec == -1 )
                        info ( "Please select a section first" )
                    else 
                        sql.insert ( "doc (document,sec) values ( [.V_C],[Sec_oid])" )
                        Doc_oid = _LAST_OID
                    end
                    break
            end
        end
    end
end

form main ()

int Pos [2]

#if VIEW_MODE
    layout "Simple Notpad" sysmenu 
 e            a                     
 





                   
              e                                          a  
 k








                                                         k      
    end
#else
    layout "Simple Notpad" RESIZE sysmenu  
b      b   k      kk      kk      kk      kk      km     m
j      j   i      ii      ii      ii      ii      ii     i
e              k                   
 





                   
              e
a














              a                                          k
 f    ff    f  g  gl                   l      c    cd    d       
    end
#endif

pre
    int i 
    text str

    switch ( LOCALLANGI () & 0xff )
        case 0x09       //English

            break
        case 0x1d       //swedish

            break
        case 0x0a       //Spanish

            break
        case 0x0c       //French

            break
        case 0x07       //German
        
            break
        case 0x10       //Italian 

            break

    end

    set_prof_file ( ".\\settings.ini" )

    for ( i = 1; i < 7; ++ i )
        reg_sec ( "settings" + i )
        str = reg_str ( "label" )
        if ( str != "" )
            Label [i] = str
        end
        str = reg_str ( "format" )
        if ( str != "" )
            charfmt2 [i] = BASE64_DEC ( str )
        end

        str = reg_str ( "temlabel" )
        if ( str != "" )
            Tem_label [i] = str
        end
        str = reg_str ( "template" )
        if ( str != "" )
            Template [i] = BASE64_DEC ( str )
        end
    end

    charformat._size = sizeof ( charformat ) 
#if ! VIEW_MODE
    .menu ( menu1 )
#endif
    db.sqlite ( "nots.db" )
    if ( sql.EXEC_NOERR ( "select * from line" ) )  //Create tabel
    
        foreach ( Init_db )
            sql.exec ( Init_db [] )
        end
        sql.insert ( "doc_text values (1,[Welcome])" )
        sql.insert ( "sections values ( 'Welcome',10)" )
        sql.insert ( "doc (document,first_line,sec) values ( 'to a simple notpad','Welcome',1 )" )

    end





    //~ .columnwidth ( V_DOC, "300|50|50" )
      
    sql.select ( "sec as section,rowid as '@oi' from sections" )
    .COLUMNLABEL ( V_Sec, sql )
    .columnwidth ( V_Sec, "155" )
    .additem_clr ( V_Sec, sql )

    .sendmessage ( V_TXT, EM_SHOWSCROLLBAR, 1, 1 )
    .sendmessage ( V_TXT, EM_SETEVENTMASK, 0, 0x04000000 )  //ENM_LINK 

    .sendmessage ( V_TXT, EM_SETUNDOLIMIT, 30, 0 )
    .richtext ( V_TXT, Init_rich )

    sql.select ( "document,first_line as '@tt',rowid as '@oi' from doc limit 1" )
    .label ( V_DOC, sql )
    .columnwidth ( V_DOC, "155" )
    .sendmessage ( V_TXT, EM_SETZOOM, 130, 100 )
    .SETCHANGED ( V_TXT, 0 )

#if VIEW_MODE
    .sendmessage ( V_TXT, EM_SETOPTIONS, ECOOP_OR, ECO_READONLY )
#endif
    .display ()
end
field
    on_close    
        save_settings ()
    end
M_EXIT  
    select
        save_settings ()
        .close ( 0 ) 
    end

MNS     //New section
    select 
        int i, z

        if ( name ( "section", 0 ) == IDOK )
            sql.select ( "sec as section,rowid as '@oi' from sections" )
            .additem_clr ( V_Sec, sql )
        end
    end
MDS    //Delete section
    select
        int i

        if ( Sec != -1 )
            i = .ITEMCOUNT ( V_DOC )
            if ( i ) 
                if ( ! ask ( "Delete [#.V_Sec] ?\nWarning there is [#i] documents in this section ?" ) )
                    return
                end
                if ( ! ask ( "Are You sure, all the documents is also deleted ?" ) )
                    return
                end
            else 
                if ( ! ask ( "Delete [#.V_Sec] ?" ) )
                    return
                end
            end

            i = .oid ( V_Sec, Sec )
            sql.begin ()
            sql.delete ( "doc_text where id=(select oid from doc where sec=[Sec_oid])" )
            sql.delete ( "doc where sec=[Sec_oid]" )
            sql.delete ( "sections where rowid=[i]"  )
            sql.commit ()
            sql.select ( "sec as section,rowid as '@oi' from sections" )
            .additem_clr ( V_Sec, sql )
            .delallitem ( V_DOC )
            Doc = -1
        end
    end
MND     //New document
    select
        if ( Sec == -1 )
            info ( "Please choose a section first" )
            return
        end
        if ( name ( "document", 1 ) == IDOK )            
            sql.select ( "document,first_line as '@tt',rowid as '@oi' from doc where sec=[Sec_oid] order by sec,document" )
            .additem_clr ( V_DOC, sql ) 
            .richtext ( V_TXT, Init_rich )            
        end
    end
MDD     //Delete document
    select
        int i

        if ( Doc != -1 )
            if ( ask ( "Delete " + .item ( V_DOC, Doc, 0 ) + " ?" ) )
                i = .oid ( V_DOC, Doc )
                sql.begin ()
                sql.delete ( "doc_text where id=[i]" )
                sql.delete ( "doc where rowid=[i]" )
                sql.commit ()
                .deleteitem ( V_DOC, Doc )
                .richtext ( V_TXT, Init_rich )
            end
        end
     end
  
#if ! VIEW_MODE
M_LOAD
    select
        text file
        int f

        if ( Doc != -1 )
            sql.select ( "filename from doc where rowid=" + .oid ( V_DOC, Doc ) )
            file = load_dlg ( sql.filename, "", "Rich Text Format (*.rtf)|*.rtf|Text Document (*.txt)|*.txt|Program code (*.sw)|*.sw|All Files (*.*)|*.*||" ) 
            if ( file == "" )
                return 
            end
            if ( fopen_bin ( 1, file ) == 0 )
                info ( "Can't open " + file )
                return
            end

            if ( file != sql.filename )
                sql.update ( "doc set filename=[file] where rowid=" + .oid ( V_DOC, Doc ) )
            end
            if ( RSUBSTR ( file, 0, "." ) != "rtf" )  //reverse substring, with '.' as delemitter = the extension
                f = true
            end
            file = fread ( 1, 5000 ) 
            while ( ! feof ( 1 ) )
                file += fread ( 1, 5000 ) 
            wend
            close ( 1 )
            if ( f )
                .value ( V_TXT, file )
            else
                .richtext ( V_TXT, file )
            end
            .click ( B_SAVE_BLOB )
         else
            info ( "Missing document" )
        end
    end
#endif
M_SAVE
    select
        text file, tx
        if ( Doc != -1 )
            sql.select ( "*,filename from doc where rowid=" + .oid ( V_DOC, Doc ) )
            file = save_dlg ( sql.filename, "", "Rich Text Format (*.rtf)|*.rtf|Text Document (*.txt)|*.txt|Program code (*.sw)|*.sw|All Files (*.*)|*.*||" ) 
            if ( file == "" )
                return 
            end
            if ( RSUBSTR ( file, 0, "." ) != "rtf" )  //reverse substring, with '.' as delemitter = the extension
                fcreate ( 1, file )
                fwrite ( 1, .V_TXT ) 
            else
                fcreate_bin ( 1, file )
                tx = .richtext ( V_TXT )
                fwrite ( 1, tx )
            end
            close ( 1 )
            if ( file != sql.filename )
                sql.update ( "doc set filename=[file] where rowid=" + .oid ( V_DOC, Doc ) )
            end
        else
            info ( "Missing document" )
        end
    end

M_SQL
    select 
        x_sql ()
    end
e: V_Sec LC allways
    select_item ( int i )
        Sec = i
        if ( check_changed () )
            return
        end
        if ( i != -1 )            
            Sec_oid = .oid ( V_Sec, i )
            sql.select ( "document,first_line as '@tt',rowid as '@oi'  from doc where sec=[Sec_oid] order by sec,document" )
            .additem_clr ( V_DOC, sql )
            Doc = -1
            .richtext ( V_TXT, Init_rich )
            .sendmessage ( V_TXT, EM_SETZOOM, 130, 100 )
            .SETCHANGED ( V_TXT, 0 )   

        end
    end
#if ! VIEW_MODE
b: B_SAVE_BLOB BT "Save"
    select
        int z, i, j
        text x, x1
        j = .sendmessage ( V_TXT, EM_GETLINECOUNT, 0, 0 )
        for ( i = 0; i < j; ++ i )
            //create tooltip text
            z = .sendmessage ( V_TXT,  EM_LINELENGTH, .sendmessage ( V_TXT, EM_LINEINDEX, i, 0 ), 0 )
            if ( z )
                x1 = int2str ( z )              //EM_GETLINE need the first word to be the buffer size
                malloc ( x1.vardef, z + 4 )     //alloc the string and set length
                .sendmessage ( V_TXT, EM_GETLINE, i, str_ptr ( x1 ) )  //lparam points to the real string 
                x1 = left ( x1, z )    
                x1 = trim ( x1 )        //remove space before and after text
                x += x1 + "\n"
                if ( strlen ( x ) > 100 )
                    break
                end
            end
        end
        if ( Doc != -1 )
            z = .oid ( V_DOC, Doc )
            .updateitem1 ( V_DOC, Doc, 1, left ( x, 100 ) )
            sql.update ( "doc set first_line=[x] where rowid=[z]" )

            sql.select ( "id from doc_text where id=[z]" )
            x = .richtext ( V_TXT )
            if ( sql.rows () )        
                sql.update ( "doc_text set doc =[x] where id=[z]" )
            else
                sql.insert ( "doc_text values ([z],[x])" )
            end
            sql.select ( "document,first_line as '@tt',rowid as '@oi'  from doc where sec=[Sec_oid] order by sec,document" )
            //the value of @oi  can be read whith ".oid ( V_DOC, Doc )"
            //@tt is the tooltip
            .additem_clr ( V_DOC, sql )

        end
        .SETCHANGED ( V_TXT, 0 )        
    end
#endif

a: V_DOC LC allways y2 - 10, ANCHOR_BOTTOM
    PRESELECT_ITEM ( int i )
        if ( i != -1 )
            if ( check_changed () )
                return 0
            end
        end
    end
    deselect_item ( int i )
        Doc = -1
    end
    select_item ( int i )
        char slask 300
        int z

        Doc = i
        z = .oid ( V_DOC, Doc )
        Pos [0] = 0
        Pos [1] = 0
        if ( z != -1 )
            sql.select ( "doc from doc_text where id=[z]" )
            if ( sql.doc != "" )
                .richtext ( V_TXT, sql.doc )
            else
                .richtext ( V_TXT, Init_rich )

                charfmt2._size = sizeof ( charfmt2 ) 
                charfmt2.mask = -1

                .sendmessage ( V_TXT, EM_GETCHARFORMAT, 1, charfmt2 )

                .sendmessage ( V_TXT, EM_EXSETSEL, 1, & Pos ) 

                .SendMessage ( V_TXT, EM_REPLACESEL, 1, & "\n"  );
                .sendmessage ( V_TXT, EM_EXSETSEL, 1, & Pos ) 

                charfmt2.effects &= ~ CF_BACKCOLOR //CF_AUTOBACKCOLOR
                charfmt2.height = 230
                charfmt2._color = color.blue
                charfmt2.bgcolor = color.yellow
                .sendmessage ( V_TXT, EM_SETCHARFORMAT, 1, charfmt2 )

                paraformat._size = sizeof ( paraformat )
                paraformat.mask = PFM_ALIGNMENT
                paraformat.wAlignment = 1       //left
                .sendmessage ( V_TXT, EM_SETPARAFORMAT, 0, paraformat )

                .sendmessage ( V_TXT, EM_EXSETSEL, 1, & Pos ) 
                .SendMessage ( V_TXT, EM_REPLACESEL, 1, str_ptr ( slask )  );
            end
        end
        .SETCHANGED ( V_TXT, 0 )        
        .sendmessage ( V_TXT, WM_LBUTTONDOWN, MK_LBUTTON, 0x10001 )
        .sendmessage ( V_TXT, WM_LBUTTONUP, MK_LBUTTON, 0x10001 )
        .sendmessage ( V_TXT, EM_EXSETSEL, 1, & Pos ) 

        .sendmessage ( V_TXT, EM_SETZOOM, 130, 100 )
    end
  
#if ! VIEW_MODE


k:  B_FMT1 BT, display ( Tem_label [1] )
    RIGHT_CLICK ()
        clipb ( 1 )
    end
    select
         set_fmt ( 11 )
    end
k:  B_FMT2 BT, display ( Tem_label [2] )
    RIGHT_CLICK ()
        clipb ( 2 )
    end
    select
         set_fmt ( 12 )
    end
k:  B_FMT3 BT, display ( Tem_label [3] )
    RIGHT_CLICK ()
        clipb ( 3 )
    end
    select
         set_fmt ( 13 )
    end
k:  B_FMT4 BT, display ( Tem_label [4] )
    RIGHT_CLICK ()
        clipb ( 4 )
    end
    select
         set_fmt ( 14 )
    end
k:  B_FMT5 BT, display ( Tem_label [5] )
    RIGHT_CLICK ()
        clipb ( 5 )
    end
    select
         set_fmt ( 15 )
    end
//-----------
i:  B_F1 BT, display ( Label [1] )
    RIGHT_CLICK ()
        edit ( 1 )
        .title ( B_F1, Label [1] )
    end
    select
        set_fmt ( 1 )
    end
i: B_F2 BT, display ( Label [2] )
    RIGHT_CLICK ()
        edit ( 2 )
        .title ( B_F2, Label [2] )
    end
    select
        set_fmt ( 2 )
    end
i: B_F3 BT, display ( Label [3] )
    RIGHT_CLICK ()
        edit ( 3 )
        .title ( B_F3, Label [3] )
    end
    select
        set_fmt ( 3 )
    end
i: B_F4 BT, display ( Label [4] )
    RIGHT_CLICK ()
        edit ( 4 )
        .title ( B_F4, Label [4] )
    end
    select
        set_fmt ( 4 )
    end
i: B_F5 BT, display ( Label [5] )
    RIGHT_CLICK ()
        edit ( 5 )
        .title ( B_F5, Label [5] )
    end
    select
        set_fmt ( 5 )
    end

m: BT "To clipb.", ANCHOR_XMOVE
    select
        wrclipboard ( .value ( V_TXT ) )
    end

i: BT "Current", ANCHOR_XMOVE
    select
        charfmt2._size = sizeof ( charfmt22 )
        charfmt2.mask = -1
        .sendmessage ( V_TXT, EM_GETCHARFORMAT, 1, charfmt2 )   //0 = SCF_DEFAULT  1 = SCF_SELECTION
        if ( ed_font ( true, "Current" ) == 1 )
            main.sendmessage ( V_TXT, EM_EXGETSEL, 0, & Pos ) 
            main.sendmessage ( V_TXT, WM_LBUTTONDOWN, MK_LBUTTON, 0x10001 )
            main.sendmessage ( V_TXT, WM_LBUTTONUP, MK_LBUTTON, 0x10001 )
            main.sendmessage ( V_TXT, EM_EXSETSEL, 0, & Pos ) 
        end
    end
#endif
k: V_TXT re y2 - 10, ANCHOR_RIGHT ANCHOR_BOTTOM 


?: ST status

end

query ssql

func edit ( int i ) 
    char copy 40

    charfmt2 [i]._size = sizeof ( charfmt22 )
    charfmt2.mask = -1
    charfmt2 [0] = charfmt2 [i]        

    copy = Label [i] 
    if ( ed_font ( i, Label [i] ) != IDOK )
        return
    end
    if ( copy != Label [i] )
        Save = true
    end

//~ mess ( dump ( charfmt2 [0] ) )
//~ mess ( dump ( charfmt2 [1] ) )

    if ( charfmt2 [0] != charfmt2 [i] )
        charfmt2 [i] = charfmt2 [0]    

        Save = true
    end
end

func set_fmt ( int i )    
    int Pos [2]


    main.sendmessage ( V_TXT, EM_EXGETSEL, 0, & Pos ) 

    if ( i < 9 )
        main.sendmessage ( V_TXT, EM_SETCHARFORMAT, 1 /* 1 = SCF_SELECTION */, charfmt2 [i] ) 
        if ( Pos [0] == Pos [1] )
            main.SendMessage ( V_TXT, EM_REPLACESEL, 1, & " " );
        end
    else

        main.SendMessage ( V_TXT, EM_REPLACESEL, 1, str_ptr ( Template [i - 10] ) );
    end

    //get active in richedit again
    main.sendmessage ( V_TXT, EM_EXGETSEL, 0, & Pos )   
    main.sendmessage ( V_TXT, WM_LBUTTONDOWN, MK_LBUTTON, 0x10001 )
    main.sendmessage ( V_TXT, WM_LBUTTONUP, MK_LBUTTON, 0x10001 )
    main.sendmessage ( V_TXT, EM_EXSETSEL, 0, & Pos ) 
end

form clipb ( int i) 
    layout "Copy from clipboard" sysmenu
 a                   a
 c   cd         d

      b         b  
end
pre
    .value ( V_LABEL, Tem_label [i] )
end
field
a: ctext "Copy text to clipboard and click the button"
c: RTEXT "Label"
d: V_LABEL EDIT, len=10
b: BT "Read clipboard"
    select
        text tx

        tx = clipboard ( "Rich Text Format" )    //You can check clipboad contents with clipboard.sw app
        if ( tx == "" )
            tx = clipboard ( 1 /* CF_TEXT */ )
        end
        if ( tx == "" )
            info ( "Can't find any text/richtext on clipboard.\nTry again" )
        else
            Template [i] = tx
            Save = true
            if ( trim ( .V_LABEL ) != "" )
                if ( .changed ( V_LABEL ) )
                    Tem_label [i] = .V_LABEL
                    main.value ( B_FMT1 + i - 1, .V_LABEL )
                end
            end
            .close ( 1 ) 
        end
    end
end


#include "ed_font.sw"

func save_settings () 
    if ( Save ) 
        if ( ask ( "Save settings ? " ) )
            for ( i = 1; i < 7; ++ i )
                reg_sec ( "settings" + i )
                reg_str ( "label", Label [i] )
                reg_str ( "temlabel", Tem_label [i] )
                reg_str ( "template", BASE64_ENC ( Template [i] ))
                reg_str ( "format", BASE64_ENC ( charfmt2 [i] ) )
            end
        end
    end
end

func check_changed ()
    int z

    if ( main.changed ( V_TXT ) )
        main.setchanged ( V_TXT, 0 )
        z = ask ( "The document is changed. Save ?", 0x23 )  //Add cancel button
        if ( z == IDYES )
            main.exec_trigger ( B_SAVE_BLOB, 0 )
        end
        if ( z == IDCANCEL )
            main.setchanged ( V_TXT, true )
            return true
        end
    end
    return false
end
        
