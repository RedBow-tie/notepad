
bitmap24 dn size(11, 11)  bcolor = white
...........
...........
a.........c
...........
.....z.....
...........
...........
.....b.....
...........
...........
...........
end
abca: line red
z: fill red
end

int Palette [145]  //reserv 1 dword for version and length

int Colors [16], i


form ed_font ( int wr, text lab )
    int new_font, new_size, new_bg, new_fg
    int Pos [2]

    layout "Edit style" sysmenu

 a           aa         ac           
 a           aa         a 
 a           aa         a z    zx   x   
 a           aa         a 
 a           aa         a z    zz       z
 a           aa         a z    zz       z
 a           aa         a
 a           aa         a d    dd       d
 a           aa         a       b       b

   z    zz       z                   

 a           a                           c  
end
pre
    text a

    .image ( V_FGCOLOR, dn )

    .additem ( V_SIZE, "6|7|8|9|10|11|12|13|14|15|16|18|20|22|24|26|28|32|36|38|40|44|48|54|60|66|72" ) 
    .sendmessage ( V_SIZE, 0x141, 5, 0 )
    .display ()

    if ( wr == 0 )       
        charfmt2.mask &= ~ ( CF_SIZE | CF_BACKCOLOR | CF_CHARSET ) 
    else
        .view ( V_TLABEL )
        .view ( V_LABEL )
    end

    .color ( V_FGCOLOR, charfmt2._color )
    .color ( V_BGCOLOR, charfmt2.bgcolor )

    if ( Palette [1] == 0 )
        create_palette ( & Palette )
        Palette [134] = rgb ( 255,224,130 )  //Gold
    end
    .load_palette ( V_FGCOLOR, & Palette )
    .load_palette ( V_BGCOLOR, & Palette )
end
    post
        int i 

        if ( .domodal () != IDOK )
            return 0
        end
        main.sendmessage ( V_TXT, EM_EXGETSEL, 0, & Pos ) 
        main.sendmessage ( V_TXT, WM_LBUTTONDOWN, MK_LBUTTON, 0x10001 )
        main.sendmessage ( V_TXT, WM_LBUTTONUP, MK_LBUTTON, 0x10001 )
        main.sendmessage ( V_TXT, EM_EXSETSEL, 0, & Pos ) 
    end
field
c: V_FONT FONT "", display ( charfmt2.facename )
    value_change  
        if ( charfmt2.facename != .V_FONT )
            charfmt2.facename = .V_FONT
            new_font = true
        end
    end
z: "Size"
x: V_SIZE CBE, display ( charfmt2.height / 20 )
    enter
        i = .V_SIZE        
    end
    leave
        if ( i != .V_SIZE )
            new_size = true
            charfmt2.height = 20 * atoi ( .V_SIZE )
        end
    end
/*
    value_change
        if ( i != .V_SIZE )
            new_size = true
            charfmt2.height = 20 * atoi ( .V_SIZE )
        end
    end
    */
z: "Fg.color"
z: V_FGCOLOR colorcontrol
    select
        new_fg = true // mess ( hex (
        charfmt2._color = .color ( V_FGCOLOR )

        foreach ( Palette = 1 )
            if ( charfmt2._color == Palette [] )
                return
            end
        end
        insert ( & Palette, 135 )
        Palette [135] = charfmt2._color
        .load_palette ( V_FGCOLOR, & Palette )
        .load_palette ( V_BGCOLOR, & Palette )
        //.check ( V_AC, 0 )
    end
z: "Bg.color"
z: V_BGCOLOR colorcontrol
    select 
        new_bg = true
        charfmt2.bgcolor = .color ( V_BGCOLOR )
        foreach ( Palette = 1 )
            if ( charfmt2.bgcolor == Palette [] )
                return
            end
        end
        insert ( & Palette, 135 )
        Palette [135] = charfmt2.bgcolor
        .load_palette ( V_BGCOLOR, & Palette )
        .load_palette ( V_FGCOLOR, & Palette )
        //.check ( V_AC, 0 )
    end
/*
z: V_COLOR ltext
z: BT_COLOR bt size ( 10, 12 )  x1 - 3  
    select
        i = colordlg ( .get_bcolor ( V_COLOR ), & Colors  )
        .bcolor ( V_COLOR, i )
    end
*/
a: V_BOLD CHECK "Bold", display ( charfmt2.effects & CF_BOLD )
    select
        charfmt2.effects &= ~CF_BOLD
        charfmt2.effects |= CF_BOLD * .checked ( V_BOLD )
    end
a: V_ITALIC CHECK "Italic", display ( charfmt2.effects &CF_ITALIC )
    select
        charfmt2.effects &= ~CF_ITALIC
        charfmt2.effects |= CF_ITALIC * .checked ( V_ITALIC )
    end
a: V_UNDERLINE CHECK "Underline", display ( charfmt2.effects & CF_UNDERLINE )
    select
        charfmt2.effects &= ~CF_UNDERLINE
        charfmt2.effects |= CF_UNDERLINE * .checked ( V_UNDERLINE )
    end
a: V_STRIKEO CHECK "Strikeout", display ( charfmt2.effects & CF_STRIKEOUT )
    select
        charfmt2.effects &= ~CF_STRIKEOUT
        charfmt2.effects |= CF_STRIKEOUT * .checked ( V_STRIKEO )
    end
a: V_PROT CHECK "Protected", display ( charfmt2.effects & CF_PROTECTED )
    select
        charfmt2.effects &= ~CF_PROTECTED
        charfmt2.effects |= CF_PROTECTED * .checked ( V_PROT )
    end
a: V_LINK CHECK "Link", display ( charfmt2.effects & CF_LINK )
    select
        charfmt2.effects &= ~CF_LINK
        charfmt2.effects |= CF_LINK * .checked ( V_LINK )
    end
a: V_SMALL CHECK "Smallcaps", display ( charfmt2.effects & CF_SMALLCAPS )
    select
        charfmt2.effects &= ~CF_SMALLCAPS
        charfmt2.effects |= CF_SMALLCAPS * .checked ( V_SMALL )
    end
a: V_ALL CHECK "Allcaps", display ( charfmt2.effects & CF_ALLCAPS )
    select
        charfmt2.effects &= ~CF_ALLCAPS
        charfmt2.effects |= CF_ALLCAPS * .checked ( V_ALL )
    end
a: V_HIDDEN CHECK "Hidden", display ( charfmt2.effects & CF_HIDDEN )
    select
        charfmt2.effects &= ~CF_HIDDEN
        charfmt2.effects |= CF_HIDDEN * .checked ( V_HIDDEN )
    end
a: V_OUTLINE CHECK "Outline", display ( charfmt2.effects & CF_OUTLINE )
    select
        charfmt2.effects &= ~CF_OUTLINE
        charfmt2.effects |= CF_OUTLINE * .checked ( V_OUTLINE )
    end
a: V_SHADDOW CHECK "Shaddow", display ( charfmt2.effects & CF_SHADOW )
    select
        charfmt2.effects &= ~CF_SHADOW
        charfmt2.effects |= CF_SHADOW * .checked ( V_SHADDOW )
    end
a: V_EMBOSS CHECK "Emboss", display ( charfmt2.effects & CF_EMBOSS )
    select
        charfmt2.effects &= ~CF_EMBOSS
        charfmt2.effects |= CF_EMBOSS * .checked ( V_EMBOSS )
    end
a: V_IMPRINT CHECK "Imprint", display ( charfmt2.effects & CF_IMPRINT )
    select
        charfmt2.effects &= ~CF_IMPRINT
        charfmt2.effects |= CF_IMPRINT * .checked ( V_IMPRINT )
    end
a: V_DIS CHECK "Disabled", display ( charfmt2.effects & CF_DISABLED )
    select
        charfmt2.effects &= ~CF_DISABLED
        charfmt2.effects |= CF_DISABLED * .checked ( V_DIS )
    end
a: V_SUBSC CHECK "Subscript", display ( charfmt2.effects & CF_SUBSCRIPT )
    select
        charfmt2.effects &= ~CF_SUBSCRIPT
        charfmt2.effects |= CF_SUBSCRIPT * .checked ( V_SUBSC )
    end
a: V_SUPER CHECK "Superscript", display ( charfmt2.effects & CF_SUPERSCRIPT )
    select
        charfmt2.effects &= ~CF_SUPERSCRIPT
        charfmt2.effects |= CF_SUPERSCRIPT * .checked ( V_SUPER )
    end
a: V_BG CHECK "BgColor", display ( ! charfmt2.effects & CF_BACKCOLOR )
    select
        charfmt2.effects &= ~CF_BACKCOLOR
        charfmt2.effects |= CF_BACKCOLOR * ! .checked ( V_BG )
        //.check ( V_AC, 0 )
    end
a: V_AC CHECK "Color", display ( ! charfmt2.effects & CF_COLOR )
    select
        charfmt2.effects &= ~CF_COLOR
        charfmt2.effects |= CF_COLOR * ! .checked ( V_AC )
    end
d: V_TLABEL rtext "Label"  hidden
d: V_LABEL EDIT hidden, display( lab )
b: IDOK BT "Ok" 
    select
        if ( wr )
            Label [wr] = .V_LABEL
            main.sendmessage ( V_TXT, EM_EXGETSEL, 0, & Pos ) 
            charfmt2.mask |= CF_SIZE * new_size | CF_BACKCOLOR * new_bg | CF_CHARSET * new_font 
            main.sendmessage ( V_TXT, EM_SETCHARFORMAT, 1 /* 8 = SCF_USEUIRULES */, charfmt2 )
            if ( Pos [0] == Pos [1] )
                main.SendMessage ( V_TXT, EM_REPLACESEL, 0, & " " );
            end
        end
    end
end



/*
CF_BOLD			0x00000001
CF_ITALIC			0x00000002
CF_UNDERLINE		0x00000004
CF_STRIKEOUT		0x00000008
CF_PROTECTED		0x00000010
CF_LINK			0x00000020
CF_AUTOCOLOR		0x40000000		

CF_SMALLCAPS		0x00000040	
CF_ALLCAPS 		0x00000080	
CFM_HIDDEN			0x00000100	
CFM_OUTLINE 		0x00000200	
CFM_SHADOW			0x00000400	
CFM_EMBOSS			0x00000800	
CFM_IMPRINT 		0x00001000	
CFM_DISABLED		0x00002000
CFM_REVISED 		0x00004000

CFM_REVAUTHOR		0x00008000
CF_SUBSCRIPT		0x00010000	
CF_SUPERSCRIPT 	0x00020000	
//~ CFM_ANIMATION		0x00040000	
//~ CFM_STYLE			0x00080000	
//~ CFM_KERNING 		0x00100000
//~ CFM_SPACING 		0x00200000
//~ CFM_WEIGHT			0x00400000
//~ CFM_UNDERLINETYPE	0x00800000	

*/
