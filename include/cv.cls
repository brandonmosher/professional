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
\newcommand{\cvSectionContentTopSkip}{0mm}

%-------------------------------------------------------------------------------
%                cvsection
%-------------------------------------------------------------------------------

% cvsection styles
\newcommand*{\cvsectionstyle}[1]{{\fontsize{16pt}{1em}\bodyfont\bfseries\color{text}\@sectioncolor #1}}

% usage: \cvsection{<section-title>}
\newcommand{\cvsection}[1]{%
  \vspace{\cvSectionTopSkip}
  \cvsectionstyle{#1}
  \phantomsection
  \color{gray}\vhrulefill{0.9pt}
  \\
}

%-------------------------------------------------------------------------------
%                cvsubsection
%-------------------------------------------------------------------------------

% cvsubsection styles
\newcommand*{\cvsubsectionstyle}[1]{{\fontsize{12pt}{1em}\bodyfont\scshape\textcolor{text}{#1}}}

% usage: \cvsubsection{<subsection-title>}
\newcommand{\cvsubsection}[1]{%
  \vspace{\cvSectionContentTopSkip}
  \cvsubsectionstyle{#1}
  \phantomsection
  \\
}

%-------------------------------------------------------------------------------
%                cvparagraph
%-------------------------------------------------------------------------------

% cvparagraph styles
\newcommand*{\cvparagraphstyle}{\fontsize{9pt}{1em}\bodyfontlight\upshape\color{text}}

% usage \cvparagraph{<text>}
\newenvironment{cvparagraph}{%
  \vspace{\cvSectionContentTopSkip}
  \cvparagraphstyle
}{%
  \par
}

%-------------------------------------------------------------------------------
%                cventries
%-------------------------------------------------------------------------------

% usage \begin{cventries} ... \end{cventreis}
\newenvironment{cventries}{%
  \vspace{\cvSectionContentTopSkip}
}{%
  \par
}

%-------------------------------------------------------------------------------
%                cventry
%-------------------------------------------------------------------------------

% cventry style
\newcommand*{\cventrytitlestyle}[1]{{\fontsize{10pt}{1em}\bodyfont\bfseries\color{darktext} #1}}
\newcommand*{\cventrypositionstyle}[1]{{\fontsize{8pt}{1em}\bodyfont\scshape\color{graytext} #1}}
\newcommand*{\cventrydatestyle}[1]{{\fontsize{8pt}{1em}\bodyfontlight\slshape\color{graytext} #1}}
\newcommand*{\cventrylocationstyle}[1]{{\fontsize{9pt}{1em}\bodyfontlight\slshape\color{awesome} #1}}
\newcommand*{\cventrydescriptionstyle}[1]{{\fontsize{9pt}{1em}\bodyfontlight\upshape\color{text} #1}}

% usage \cventrycompact{<organization>}{<position>}{<location>}{<date>}{<description>}
\newcommand*{\cventrycompact}[5]{%
  \cventrytitlestyle{#1} \cventrypositionstyle{#2}\hfill\cventrylocationstyle{#3} \cventrydatestyle{#4}\\
  \cventrydescriptionstyle{#5}
}

% usage \cventry{<organization>}{<position>}{<location>}{<date>}{<description>}
\newcommand*{\cventry}[5]{%
  \cventrytitlestyle{#1}\hfill\cventrylocationstyle{#3}\\
  \ifstrempty{#2}{}{
  \cventrypositionstyle{#2}\hfill\cventrydatestyle{#4}\\
  }
  \cventrydescriptionstyle{#5}
}

%-------------------------------------------------------------------------------
%                cvhonor
%-------------------------------------------------------------------------------

% cvhonor styles
\newcommand*{\honortitlestyle}[1]{{\fontsize{9pt}{1em}\bodyfont\color{graytext} #1}}
\newcommand*{\honorpositionstyle}[1]{{\fontsize{9pt}{1em}\bodyfont\bfseries\color{darktext} #1}}
\newcommand*{\honordatestyle}[1]{{\fontsize{9pt}{1em}\bodyfont\color{graytext} #1}}
\newcommand*{\honorlocationstyle}[1]{{\fontsize{9pt}{1em}\bodyfontlight\slshape\color{awesome} #1}}

% usage \cvhonor{<position>}{<title>}{<location>}{<date>}
\newcommand*{\cvhonor}[4]{%
  \makebox[1.5cm]{\honordatestyle{#4}}\honorpositionstyle{#1}, \honortitlestyle{#2} \hfill \honorlocationstyle{#3}
}

%-------------------------------------------------------------------------------
%                cvskillset
%-------------------------------------------------------------------------------

% cvskillset styles
\newcommand*{\skillsetcategorystyle}[1]{{\fontsize{10pt}{1em}\bodyfont\bfseries\color{darktext}#1}}
\newcommand*{\skillsetstyle}[1]{{\fontsize{9pt}{1em}\bodyfontlight\color{text}#1}}

% usage \cvskillset[<category><skillset>]
\newcommand*{\cvskillset}[2]{%
    \skillsetcategorystyle{#1}\skillsetstyle{#2}
}

%-------------------------------------------------------------------------------
%                cvitems
%-------------------------------------------------------------------------------

\newenvironment{cvitems}{}{}

\newcommand*{\cvitem}[1]{\hangindent=1em\makebox[1em]{\textbullet}#1\\}