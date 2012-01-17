<?xml version='1.0'?> 
<xsl:stylesheet  
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="1.0"> 

<!-- ********************************************************************

     PacketFence Documentation Docbook FO Parameters

     This file is part of the PacketFence project.
     Authors: 
       - Olivier Bilodeau <obilodeau@inverse.ca>

     Copyright (C) 2011 Inverse inc.
     License: GFDL 1.2 or later. http://www.gnu.org/licenses/fdl.html

     ******************************************************************** -->

<!--
    Global Tasks
    
    TODO prettier revhistory
    TODO prettier Table of Contents
    TODO generate PDF table of contents (like OSX's Preview shows on the right hand side)
    TODO title 2
    - align with text?
    - more above whitespace
    TODO change the bullet for a prettier one
    TODO title 3 and 4 
    - align with text?
    - should be easier to differentiate (check network guide)
    TODO icon on line wrap in monospace boxes
    TODO caution, notes, warnings, etc.
    - box around it
    - sexy icon
    TODO -> is converted into an arrow but it's not pretty (is it font or docbook-thingy?)

-->

  <!-- Load default values -->
  <!--<xsl:import href="/opt/local/share/xsl/docbook-xsl/fo/docbook.xsl"/>-->
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl/fo/docbook.xsl"/> 

  <!-- title page extra styling -->
  <xsl:import href="titlepage-fo.xsl"/>

  <!-- header / footer extra styling -->
  <xsl:import href="headerfooter-fo.xsl"/>

  <!-- attaching an image to the verso legalnotice component -->
  <xsl:template match="legalnotice" mode="book.titlepage.verso.mode">
    <xsl:apply-templates mode="titlepage.mode"/>
    <fo:block text-align="right">
      <fo:external-graphic src="url('docs/images/inverse-logo.jpg')" width="3in" content-width="scale-to-fit"/>
    </fo:block>
  </xsl:template>

  <!-- stylesheet options -->
  <xsl:param name="title.font.family">Palatino</xsl:param>
  <xsl:param name="chapter.autolabel" select="0"/>
  <xsl:attribute-set name="component.title.properties">
    <xsl:attribute name="padding-bottom">2.5em</xsl:attribute>
    <xsl:attribute name="border-bottom">solid 2px</xsl:attribute>
    <xsl:attribute name="margin-bottom">1em</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="border-bottom">solid 1px</xsl:attribute>
    <xsl:attribute name="margin-bottom">1em</xsl:attribute>
  </xsl:attribute-set>

  <!-- revision table layout -->
  <xsl:attribute-set name="revhistory.title.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="revhistory.table.properties">
    <xsl:attribute name="break-before">page</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="revhistory.table.cell.properties">
    <xsl:attribute name="border">solid</xsl:attribute>
  </xsl:attribute-set>

  <!-- Table Of Contents (TOC) options -->
  <!-- We only want 2 level of ToC depth -->
  <xsl:param name="toc.section.depth" select="1"/>

  <!-- grey boxes around code (screen, programlisting) -->
  <xsl:param name="shade.verbatim" select="1"/>
  <xsl:attribute-set name="shade.verbatim.style">
    <xsl:attribute name="background-color">#E0E0E0</xsl:attribute>
    <xsl:attribute name="border">solid</xsl:attribute>
    <!-- prevent page breaks in screen and programlisting tags -->
    <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <!-- breaking long lines in code (screen, programlisting) -->
  <xsl:attribute-set name="monospace.verbatim.properties">
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  </xsl:attribute-set>

  <!-- don't show raw links in [ .. ] after a link -->
  <xsl:param name="ulink.show" select="0"/>

  <!-- blue underlined hyperlink -->
  <xsl:attribute-set name="xref.properties">
    <xsl:attribute name="color">blue</xsl:attribute>
    <xsl:attribute name="text-decoration">underline</xsl:attribute>
  </xsl:attribute-set>

  <!-- copyright in range instead of seperated years -->
  <xsl:param name="make.year.ranges" select="1" />

  <!-- variablelist behavior (asciidoc's term:: lists) -->
  <!-- <xsl:param name="variablelist.term.break.after" select="1" /> -->

</xsl:stylesheet>
<!-- vim: set shiftwidth=2 tabstop=2 expandtab: -->
