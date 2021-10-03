%-------------------------------------------------------------------------------
%                Identification
%-------------------------------------------------------------------------------
\ProvidesClass{cv}[2021/08/11 v1.0 CV Class]
\NeedsTeXFormat{LaTeX2e}

\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{professional}
}
\ProcessOptions\relax
\LoadClass{professional}

% section spacing
\newcommand{\cvSectionTopSkip}{1mm}

%-------------------------------------------------------------------------------
%                cvsection
%-------------------------------------------------------------------------------

% usage: \cvsection{<section-title>}
\newcommand{\cvsection}[1]{%
  \vspace{\cvSectionTopSkip}
  \headsection{#1}
  \phantomsection
  \color{gray}\vhrulefill{0.9pt}
  \\
}

%-------------------------------------------------------------------------------
%                cvsubsection
%-------------------------------------------------------------------------------

% usage: \cvsubsection{<subsection-title>}
\newcommand{\cvsubsection}[1]{%
  \vspace{\cvSectionTopSkip}
  \headb{\color{text} #1}
  \phantomsection
  \\
}

%-------------------------------------------------------------------------------
%                cvparagraph
%-------------------------------------------------------------------------------

% usage \cvparagraph{<text>}
\newenvironment{cvparagraph}{\cvparagraphstyle}{\par}

%-------------------------------------------------------------------------------
%                cventries
%-------------------------------------------------------------------------------

% usage \begin{cventries} ... \end{cventreis}
\newenvironment{cventries}{}{\par}

%-------------------------------------------------------------------------------
%                cventry
%-------------------------------------------------------------------------------

% usage \cventry{<date>}{<position>}{<organization>}{<location>}{<description>}

\newcommand*{\cventry}[5]{%
  \ifstrempty{#1}{}{\headd{#1}\\}%
  \ifstrempty{#2#3#4}{}{%
    \ifstrempty{#2}{}{\headc{\cvbold{#2\ifstrempty{#3#4}{}{, }}}}%
    \ifstrempty{#3}{}{\headd{\color{graytext}#3\ifstrempty{#4}{}{, }}}%
    \ifstrempty{#4}{}{\headd{\color{graytext}#4}}%
    \\
  }%
  \begin{cvparagraph}%
    #5
  \end{cvparagraph}%
}%

%-------------------------------------------------------------------------------
%                cvskillset
%-------------------------------------------------------------------------------

\newenvironment{skillsets}{}{\par}

\newenvironment{skills}{\begin{separatedItems}{, }}{\end{separatedItems}}
\newcommand*{\skill}[1]{\separatedItem{#1}}

%-------------------------------------------------------------------------------
%                cvitems
%-------------------------------------------------------------------------------

\newenvironment{cvitems}{}{}

\newcommand*{\cvitem}[1]{\hangindent=1em\makebox[1em]{\textbullet}#1\\}

% Environments for sections
\newenvironment{cv}{}{\par}

\newenvironment{summary}{}{\par}

\newenvironment{experience}{}{\par}

\newenvironment{projects}{}{\par}

\newenvironment{education}{}{\par}

\newcommand{\degreeSep}{ \textbar}

\newenvironment{degrees}{\begin{separatedItems}{\degreeSep}}{\end{separatedItems}}

\newcommand*{\degree}[1]{\separatedItem{#1}}

\newenvironment{hobbies}{}{\par}

\newenvironment{clearances}{\begin{cvitems}}{\end{cvitems}}

\newcommand*{\clearanceStatus}[1]{\def\@clearanceStatus{#1}}
\newcommand*{\clearanceLevel}[1]{\def\@clearanceLevel{#1}}
\newcommand*{\clearanceDate}[1]{\def\@clearanceDate{#1}}
\newcommand*{\investigationStatus}[1]{\def\@investigationStatus{#1}}
\newcommand*{\investigationType}[1]{\def\@investigationType{#1}}
\newcommand*{\investigationDate}[1]{\def\@investigationDate{#1}}
\newcommand*{\polygraphStatus}[1]{\def\@polygraphStatus{#1}}
\newcommand*{\polygraphType}[1]{\def\@polygraphType{#1}}
\newcommand*{\polygraphDate}[1]{\def\@polygraphDate{#1}}

% usage
%\clearance
\newcommand*{\clearance}{\cvitem{\itemstyle{%
    \@clearanceStatus~\@clearanceLevel~(\@clearanceDate);~
    \@investigationStatus~\@investigationType~(\@investigationDate);~
    \@polygraphStatus~\@polygraphType~polygraph~(\@polygraphDate).
}}}