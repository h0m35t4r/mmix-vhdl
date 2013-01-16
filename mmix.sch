<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="vgaBlue(2:1)" />
        <signal name="vgaGreen(2:0)" />
        <signal name="vgaRed(2:0)" />
        <signal name="Hsync" />
        <signal name="Vsync" />
        <signal name="char_data(63:0)" />
        <signal name="clk" />
        <signal name="vga_read_data(7:0)" />
        <signal name="char_pixel(7:0)" />
        <signal name="vga_addr(12:0)" />
        <signal name="XLXN_138(9:0)" />
        <signal name="XLXN_139(9:0)" />
        <port polarity="Output" name="vgaBlue(2:1)" />
        <port polarity="Output" name="vgaGreen(2:0)" />
        <port polarity="Output" name="vgaRed(2:0)" />
        <port polarity="Output" name="Hsync" />
        <port polarity="Output" name="Vsync" />
        <port polarity="Input" name="clk" />
        <blockdef name="font_rom">
            <timestamp>2012-2-21T19:25:58</timestamp>
            <rect width="256" x="64" y="-128" height="128" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-108" height="24" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <blockdef name="vga">
            <timestamp>2012-2-21T20:25:35</timestamp>
            <rect width="256" x="64" y="-448" height="448" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-416" y2="-416" x1="320" />
            <line x2="384" y1="-352" y2="-352" x1="320" />
            <rect width="64" x="320" y="-300" height="24" />
            <line x2="384" y1="-288" y2="-288" x1="320" />
            <rect width="64" x="320" y="-236" height="24" />
            <line x2="384" y1="-224" y2="-224" x1="320" />
            <rect width="64" x="320" y="-172" height="24" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
            <rect width="64" x="320" y="-108" height="24" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
            <rect width="64" x="320" y="-44" height="24" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="char_ctrl">
            <timestamp>2012-2-21T20:25:15</timestamp>
            <rect width="352" x="64" y="-192" height="192" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="416" y="-172" height="24" />
            <line x2="480" y1="-160" y2="-160" x1="416" />
            <rect width="64" x="416" y="-44" height="24" />
            <line x2="480" y1="-32" y2="-32" x1="416" />
        </blockdef>
        <blockdef name="core">
            <timestamp>2012-2-21T19:25:53</timestamp>
            <rect width="368" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="432" y="-172" height="24" />
            <line x2="496" y1="-160" y2="-160" x1="432" />
        </blockdef>
        <block symbolname="font_rom" name="XLXI_35">
            <blockpin signalname="clk" name="clka" />
            <blockpin signalname="vga_read_data(7:0)" name="addra(7:0)" />
            <blockpin signalname="char_data(63:0)" name="douta(63:0)" />
        </block>
        <block symbolname="char_ctrl" name="XLXI_40">
            <blockpin signalname="XLXN_138(9:0)" name="HCnt(9:0)" />
            <blockpin signalname="XLXN_139(9:0)" name="VCnt(9:0)" />
            <blockpin signalname="char_data(63:0)" name="char_data(63:0)" />
            <blockpin signalname="vga_addr(12:0)" name="char_raddr(12:0)" />
            <blockpin signalname="char_pixel(7:0)" name="char_pixel(7:0)" />
        </block>
        <block symbolname="vga" name="XLXI_41">
            <blockpin signalname="clk" name="clk" />
            <blockpin signalname="char_pixel(7:0)" name="pixel(7:0)" />
            <blockpin signalname="Hsync" name="Hsync" />
            <blockpin signalname="Vsync" name="Vsync" />
            <blockpin signalname="vgaRed(2:0)" name="vgaRed(2:0)" />
            <blockpin signalname="vgaGreen(2:0)" name="vgaGreen(2:0)" />
            <blockpin signalname="vgaBlue(2:1)" name="vgaBlue(2:1)" />
            <blockpin signalname="XLXN_138(9:0)" name="HCnt(9:0)" />
            <blockpin signalname="XLXN_139(9:0)" name="VCnt(9:0)" />
        </block>
        <block symbolname="core" name="XLXI_43">
            <blockpin signalname="clk" name="clk" />
            <blockpin name="reset" />
            <blockpin signalname="vga_addr(12:0)" name="vga_addr(12:0)" />
            <blockpin signalname="vga_read_data(7:0)" name="vga_read_data(7:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <branch name="vgaBlue(2:1)">
            <wire x2="3216" y1="2192" y2="2192" x1="3088" />
            <wire x2="3232" y1="2192" y2="2192" x1="3216" />
        </branch>
        <branch name="vgaGreen(2:0)">
            <wire x2="3216" y1="2128" y2="2128" x1="3088" />
            <wire x2="3232" y1="2128" y2="2128" x1="3216" />
        </branch>
        <branch name="vgaRed(2:0)">
            <wire x2="3216" y1="2064" y2="2064" x1="3088" />
            <wire x2="3232" y1="2064" y2="2064" x1="3216" />
        </branch>
        <branch name="Hsync">
            <wire x2="3216" y1="1936" y2="1936" x1="3088" />
            <wire x2="3232" y1="1936" y2="1936" x1="3216" />
        </branch>
        <branch name="Vsync">
            <wire x2="3216" y1="2000" y2="2000" x1="3088" />
            <wire x2="3232" y1="2000" y2="2000" x1="3216" />
        </branch>
        <iomarker fontsize="28" x="3232" y="2000" name="Vsync" orien="R0" />
        <iomarker fontsize="28" x="3232" y="1936" name="Hsync" orien="R0" />
        <iomarker fontsize="28" x="3232" y="2064" name="vgaRed(2:0)" orien="R0" />
        <iomarker fontsize="28" x="3232" y="2128" name="vgaGreen(2:0)" orien="R0" />
        <iomarker fontsize="28" x="3232" y="2192" name="vgaBlue(2:1)" orien="R0" />
        <branch name="char_data(63:0)">
            <wire x2="1760" y1="2320" y2="2384" x1="1760" />
            <wire x2="1760" y1="2384" y2="2496" x1="1760" />
            <wire x2="2256" y1="2496" y2="2496" x1="1760" />
            <wire x2="2256" y1="2496" y2="2544" x1="2256" />
            <wire x2="2256" y1="2544" y2="2544" x1="2192" />
        </branch>
        <instance x="1808" y="2640" name="XLXI_35" orien="R0">
        </instance>
        <branch name="clk">
            <wire x2="944" y1="1760" y2="1936" x1="944" />
            <wire x2="976" y1="1936" y2="1936" x1="944" />
            <wire x2="976" y1="1936" y2="2000" x1="976" />
            <wire x2="1008" y1="2000" y2="2000" x1="976" />
            <wire x2="1520" y1="1760" y2="1760" x1="944" />
            <wire x2="1520" y1="1760" y2="1936" x1="1520" />
            <wire x2="2704" y1="1936" y2="1936" x1="1520" />
            <wire x2="1520" y1="1936" y2="2544" x1="1520" />
            <wire x2="1808" y1="2544" y2="2544" x1="1520" />
        </branch>
        <iomarker fontsize="28" x="944" y="1936" name="clk" orien="R180" />
        <instance x="1760" y="2352" name="XLXI_40" orien="R0">
        </instance>
        <branch name="vga_read_data(7:0)">
            <wire x2="1648" y1="2000" y2="2000" x1="1504" />
            <wire x2="1648" y1="2000" y2="2608" x1="1648" />
            <wire x2="1808" y1="2608" y2="2608" x1="1648" />
        </branch>
        <branch name="char_pixel(7:0)">
            <wire x2="2256" y1="2320" y2="2320" x1="2240" />
            <wire x2="2704" y1="2320" y2="2320" x1="2256" />
        </branch>
        <branch name="vga_addr(12:0)">
            <wire x2="960" y1="1904" y2="2128" x1="960" />
            <wire x2="1008" y1="2128" y2="2128" x1="960" />
            <wire x2="2304" y1="1904" y2="1904" x1="960" />
            <wire x2="2304" y1="1904" y2="2192" x1="2304" />
            <wire x2="2304" y1="2192" y2="2192" x1="2240" />
        </branch>
        <instance x="2704" y="2352" name="XLXI_41" orien="R0">
        </instance>
        <branch name="XLXN_138(9:0)">
            <wire x2="1760" y1="2192" y2="2192" x1="1696" />
            <wire x2="1696" y1="2192" y2="2432" x1="1696" />
            <wire x2="3168" y1="2432" y2="2432" x1="1696" />
            <wire x2="3168" y1="2256" y2="2256" x1="3088" />
            <wire x2="3168" y1="2256" y2="2432" x1="3168" />
        </branch>
        <branch name="XLXN_139(9:0)">
            <wire x2="1760" y1="2256" y2="2256" x1="1712" />
            <wire x2="1712" y1="2256" y2="2464" x1="1712" />
            <wire x2="3152" y1="2464" y2="2464" x1="1712" />
            <wire x2="3152" y1="2320" y2="2320" x1="3088" />
            <wire x2="3152" y1="2320" y2="2464" x1="3152" />
        </branch>
        <instance x="1008" y="2160" name="XLXI_43" orien="R0">
        </instance>
    </sheet>
</drawing>