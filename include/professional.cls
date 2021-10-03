%-------------------------------------------------------------------------------
%                Identification
%-------------------------------------------------------------------------------
\ProvidesClass{professional}[2021/08/11 v1.0 Professional Class]
\NeedsTeXFormat{LaTeX2e}

%-------------------------------------------------------------------------------
%                Class options
%
% (need to be done before the external package loading, for example because
% we need \paperwidth, \paperheight and \@ptsize to be defined before loading
% geometry and fancyhdr)
%-------------------------------------------------------------------------------
% Options for draft or final
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
% Inherit options of article
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{article}
}
\ProcessOptions\relax
\LoadClass{article}

%-------------------------------------------------------------------------------
%                Misc packages
%-------------------------------------------------------------------------------

% Needed for hyperlink
\RequirePackage[hidelinks,unicode]{hyperref}
\hypersetup{%
  pdftitle={},
  pdfauthor={},
  pdfsubject={},
  pdfkeywords={}
}

% Needed to use a toolbox of programming tools
\RequirePackage{etoolbox}

%-------------------------------------------------------------------------------
%                layout
%-------------------------------------------------------------------------------

% needed to configure page layout
\RequirePackage{geometry}

% configure page margins with geometry
\geometry{left=2.0cm, top=1.5cm, right=2.0cm, bottom=2.0cm, footskip=.5cm}

% left justify text
\raggedright

%-------------------------------------------------------------------------------
%                Colors
%-------------------------------------------------------------------------------
\RequirePackage{xcolor}

% Gray-scale colors
\definecolor{white}{HTML}{FFFFFF}
\definecolor{black}{HTML}{000000}
\definecolor{darkgray}{HTML}{333333}
\definecolor{gray}{HTML}{5D5D5D}
\definecolor{lightgray}{HTML}{999999}

% Basic colors
\definecolor{green}{HTML}{C2E15F}
\definecolor{orange}{HTML}{FDA333}
\definecolor{purple}{HTML}{D3A4F9}
\definecolor{red}{HTML}{FB4485}
\definecolor{blue}{HTML}{6CE0F1}
\definecolor{hrefblue}{HTML}{0645AD}

% Text colors
\definecolor{darktext}{HTML}{414141}
\colorlet{text}{darkgray}
\colorlet{graytext}{gray}
\colorlet{lighttext}{lightgray}

% Awesome colors
\definecolor{awesome-emerald}{HTML}{00A388}
\definecolor{awesome-skyblue}{HTML}{0395DE}
\definecolor{awesome-red}{HTML}{DC3522}
\definecolor{awesome-pink}{HTML}{EF4089}
\definecolor{awesome-orange}{HTML}{FF6138}
\definecolor{awesome-nephritis}{HTML}{27AE60}
\definecolor{awesome-concrete}{HTML}{95A5A6}
\definecolor{awesome-darknight}{HTML}{131A28}

% Boolean value to switch section color highlighting
\newbool{sectionColorHighlight}
\setbool{sectionColorHighlight}{true}

% Awesome section color
\colorlet{awesome}{awesome-red}
\def\@sectioncolor#1{%
  \ifbool{sectionColorHighlight}{{\color{awesome}#1}}{#1}%
}

%-------------------------------------------------------------------------------
%                fonts
%-------------------------------------------------------------------------------
% Configure a directory location for fonts(default: 'fonts/')
\newcommand*{\fontdir}[1][fonts/]{\def\@fontdir{#1}}
\fontdir

% Needed to manage fonts
\RequirePackage[quiet]{fontspec}

% Needed to use icons from font-awesome (https://github.com/posquit0/latex-fontawesome)
\RequirePackage{fontawesome}
\RequirePackage[default,opentype]{sourcesanspro}

% Set the FontAwesome font to be up-to-date.
\setfontfamily\FA[Path=\@fontdir]{FontAwesome}

% Set font for header (default is Roboto)
\newfontfamily\headerfont[
  Path=\@fontdir,
  UprightFont=*-Regular,
  ItalicFont=*-Italic,
  BoldFont=*-Bold,
  BoldItalicFont=*-BoldItalic,
]{Roboto}

\newfontfamily\headerfontlight[
  Path=\@fontdir,
  UprightFont=*-Thin,
  ItalicFont=*-ThinItalic,
  BoldFont=*-Medium,
  BoldItalicFont=*-MediumItalic,
]{Roboto}

\newcommand*{\footerfont}{\sourcesanspro}
\newcommand*{\bodyfont}{\sourcesanspro}
\newcommand*{\bodyfontlight}{\sourcesansprolight}

%-------------------------------------------------------------------------------
%                headings
%-------------------------------------------------------------------------------
% \bfseries\color{text}\@sectioncolor
\newcommand*{\headsection}[1]{\heada{\bfseries\color{text}\@sectioncolor#1}}

\newcommand*{\headtitle}[1]{{\fontsize{20pt}{1em} #1}}
\newcommand*{\heada}[1]{{\fontsize{14pt}{1em}\bodyfont#1}}
\newcommand*{\headb}[1]{{\fontsize{12pt}{1em}\bodyfont#1}}
\newcommand*{\headc}[1]{{\fontsize{10pt}{1em}\bodyfont#1}}
\newcommand*{\headclight}[1]{{\fontsize{10pt}{1em}\bodyfontlight#1}}
\newcommand*{\headd}[1]{{\fontsize{9pt}{1em}\bodyfont#1}}
\newcommand*{\heade}[1]{{\fontsize{8pt}{1em}\bodyfont#1}}
\newcommand*{\headf}[1]{{\fontsize{7pt}{1em}\bodyfontlight#1}}
\newcommand*{\cvparagraphstyle}{\fontsize{9pt}{1.15em}\bodyfontlight\color{text}}
\newcommand*{\lettertextstyle}{\fontsize{10pt}{1.4em}\bodyfontlight\color{graytext}}

%-------------------------------------------------------------------------------
%                utilities
%-------------------------------------------------------------------------------

% Use to draw horizontal line with specific thickness
\newcommand{\vhrulefill}[1]{\leavevmode\leaders\hrule\@height#1\hfill \kern\z@}

\newcommand*{\cvbold}[1]{\bfseries\color{darktext}#1}

\newcommand*{\cvhref}[2]{\ifstrempty{#2}{#1}{\color{hrefblue}\href{#2}{#1}}}

%-------------------------------------------------------------------------------
%                titledItem
%-------------------------------------------------------------------------------

% titledItem styles
\newcommand*{\titledItemTitleStyle}[1]{{\headd{#1}}}
\newcommand*{\titledItemItemStyle}[1]{{\cvparagraphstyle#1}}

\newenvironment{titledItems}{}{}

% usage \titledItem[<label><item>]
\newcommand*{\titledItem}[2]{%
    \titledItemTitleStyle{#1}\titledItemItemStyle{#2}
}

%-------------------------------------------------------------------------------
%                separatedItem
%-------------------------------------------------------------------------------

\newcommand*{\separatedItem}[1]{%
    \ifbool{isFirstSeparatedItem}{\setbool{isFirstSeparatedItem}{false}}{\separator}#1%
}%

\newenvironment{separatedItems}[1]{%
  \newcommand{\separator}{#1}%
  \newbool{isFirstSeparatedItem}%
  \setbool{isFirstSeparatedItem}{true}%
}{}%

%-------------------------------------------------------------------------------
%                personal information
%-------------------------------------------------------------------------------
\newcommand*{\name}[2]{\def\@firstname{#1}\def\@lastname{#2}}
\newcommand*{\firstname}[1]{\def\@firstname{#1}}
\newcommand*{\lastname}[1]{\def\@lastname{#1}}
\newcommand*{\address}[1]{\def\@address{#1}}
\newcommand*{\position}[1]{\def\@position{#1}}
\newcommand*{\mobile}[1]{\def\@mobile{#1}}
\newcommand*{\email}[1]{\def\@email{#1}}
\newcommand*{\homepage}[1]{\def\@homepage{#1}}
\newcommand*{\github}[1]{\def\@github{#1}}
\newcommand*{\linkedin}[1]{\def\@linkedin{#1}}

%-------------------------------------------------------------------------------
%                header and footer
%-------------------------------------------------------------------------------
\newenvironment{header}{}{\par}

% Needed to make header & footer effeciently
\RequirePackage{fancyhdr}

% Clear all header & footer fields
\fancyhf{}

% Set offset to each header and footer
\fancyhfoffset{0em}

% Enable if you want to make header or footer using fancyhdr
\pagestyle{fancy}

% remove head rule
\renewcommand{\headrulewidth}{0pt}

% header styles
\newcommand*{\headerfirstnamestyle}[1]{\headtitle{\headerfontlight\color{graytext}#1}}
\newcommand*{\headerlastnamestyle}[1]{\headtitle{\headerfont\bfseries\color{text}#1}}
\newcommand*{\headerpositionstyle}[1]{\headd{\color{awesome}#1}}
\newcommand*{\headeraddressstyle}[1]{\headd{\headerfont\itshape\color{lighttext}#1}}
\newcommand*{\headersocialstyle}[1]{\headf{\headerfont\color{text}#1}}

% header social entries
\newcommand{\headerSocialSep}{\quad\textbar\quad}

\newenvironment{headerSocialEntries}{%
    \begin{separatedItems}{\headerSocialSep}%
}{%
    \end{separatedItems}%
}%

% usage: \headerSocialEntry{text}{icon}{url}
\newcommand*{\headerSocialEntry}[3]{%
    \ifdefvoid{#1}{}{%
        \ifblank{#1}{}%
        {%
            \separatedItem{\href{#3#1}{#2 #1}}%
        }%
    }%
}

% usage: \makeheader
\newcommand*{\makeheader}[1][C]{%
  \begin{minipage}[c]{\textwidth}
    \ifdefequal{#1}{L}{\raggedright}{\ifdefequal{#1}{R}{\raggedleft}{\centering}}
    \headerfirstnamestyle{\@firstname} \headerlastnamestyle{\@lastname}\\%
    \ifdefvoid{\@position}{}{\headerpositionstyle{\@position}\\}%
    \ifdefvoid{\@address}{}{\headeraddressstyle{\@address\\}}%
    \headersocialstyle{%
      \begin{headerSocialEntries}%
          \headerSocialEntry{\@mobile}{\faMobile}{}%
          \headerSocialEntry{\@email}{\faEnvelope}{mailto:}%
          \headerSocialEntry{\@homepage}{\faHome}{https://}%
          \headerSocialEntry{\@github}{\faGithubSquare}{https://github.com/}%
          \headerSocialEntry{\@linkedin}{\faLinkedinSquare}{https://www.linkedin.com/in/}%
      \end{headerSocialEntries}%
    }\\%
  \end{minipage}%
}

% footer styles
\newcommand*{\footerstyle}[1]{{\fontsize{8pt}{1em}\footerfont\color{lighttext}#1}}

% usage: \makefooter{<left>}{<center>}{<right>}
\newcommand*{\makefooter}[3]{%
  \fancyfoot{}
  \fancyfoot[L]{\footerstyle{#1}}
  \fancyfoot[C]{\footerstyle{#2}}
  \fancyfoot[R]{\footerstyle{#3}}
}
