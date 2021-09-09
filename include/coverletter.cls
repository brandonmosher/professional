
%-------------------------------------------------------------------------------
%                Identification
%-------------------------------------------------------------------------------
\ProvidesClass{coverletter}[2021/08/11 v1 Coverletter Class]
\NeedsTeXFormat{LaTeX2e}

\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{professional}
}
\ProcessOptions\relax
\LoadClass{professional}

%-------------------------------------------------------------------------------
%                common letterstyles
%-------------------------------------------------------------------------------

\newcommand*{\letterdatestyle}[1]{{\fontsize{9pt}{1em}\bodyfontlight\slshape\color{graytext} #1}}
\newcommand*{\lettertextstyle}{\fontsize{10pt}{1.4em}\bodyfontlight\upshape\color{graytext}}
\newcommand*{\letternamestyle}[1]{{\fontsize{10pt}{1em}\bodyfont\bfseries\color{darktext} #1}}


%-------------------------------------------------------------------------------
%                letterstart
%-------------------------------------------------------------------------------

\newenvironment{opening}{}{\par}

% usage: \lettertoname{<recipient name>}
\newcommand*{\lettertoname}[1]{\def\@lettertoname{#1}}

% lettertonamestyle
\newcommand*{\lettertonamestyle}[1]{{\fontsize{11pt}{1em}\bodyfont\bfseries\color{darktext} #1}}

% usage: \lettertoaddress{<recipient address>}
\newcommand*{\lettertoaddress}[1]{\def\@lettertoaddress{#1}}

% lettertoaddress style
\newcommand*{\lettertoaddressstyle}[1]{{\fontsize{9pt}{1em}\bodyfont\scshape\color{graytext} #1}}

% usage: \lettertitle{<title>}
\newcommand*{\lettertitle}[1]{\def\@lettertitle{#1}}

% lettertitle style
\newcommand*{\lettertitlestyle}[1]{{\fontsize{10pt}{1em}\bodyfontlight\bfseries\color{darktext} \underline{#1}}}

% usage: \letterdate{<date>}
\newcommand*{\letterdate}[1]{\def\@letterdate{#1}}

% usage: \letteropeningphrase{<phrase>}
\newcommand*{\letteropeningphrase}[1]{\def\@letteropeningphrase{#1}}

% usage: \makeletterstart
\newcommand*{\makeletterstart}{%
  \bigskip\bigskip
  \lettertonamestyle{\@lettertoname}\hfill\letterdatestyle{\@letterdate}\\
  \ifdefvoid{\@lettertoaddress}{}{\lettertoaddressstyle{\@lettertoaddress}\\}
  \bigskip\bigskip
  \ifdefvoid{\@lettertitle}
    {}
    {\lettertitlestyle{\@lettertitle}\\}
  \medskip
  \lettertextstyle{\@letteropeningphrase}
}

%-------------------------------------------------------------------------------
%                body
%-------------------------------------------------------------------------------

% Define an environment for body
\newenvironment{body}{\lettertextstyle}{}

% lettersection style
\newcommand*{\lettersectionstyle}[1]{{\fontsize{14pt}{1em}\bodyfont\bfseries\color{text}\@sectioncolor #1}}

% usage: \lettersection{<section-title>}
\newcommand{\lettersection}[2]{%
  \par\addvspace{2.5ex}
  \phantomsection{}
  \lettersectionstyle{#1}
  \color{gray}\vhrulefill{0.9pt}
  \par\nobreak\addvspace{0.4ex}
  #2\par
}

% usage \cvparagraph{<text>}
\newenvironment{clparagraphs}{}{}

% usage \cvparagraph{<text>}
\newenvironment{clparagraph}{}{\par}

%-------------------------------------------------------------------------------
%                letterend
%-------------------------------------------------------------------------------

\newenvironment{closing}{}{\par}

% usage: \letterclosingphrase{<phrase>}
\newcommand*{\letterclosingphrase}[1]{\def\@letterclosingphrase{#1}}

% usage: \makeletterend
\newcommand*{\makeletterend}{%
  \vspace{3.4mm}
  \lettertextstyle{\@letterclosingphrase}\\
  \letternamestyle{\@firstname\ \@lastname}\\
}

%-------------------------------------------------------------------------------
%                letterenclosure
%-------------------------------------------------------------------------------

\newenvironment{enclosures}{}{\par}

\newcommand*{\letterenclosurestyle}[1]{{\fontsize{10pt}{1em}\bodyfontlight\slshape\color{lighttext} #1}}

% usage: \letterenclosure[<enclosure name>]{<enclosure>}
\newcommand*{\letterenclosure}[2]{\letterenclosurestyle{#1: #2}\\}