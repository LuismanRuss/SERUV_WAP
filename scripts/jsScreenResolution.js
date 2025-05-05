function jsGet_ScreenResolution() {
    var nHeight = 0;
    var nWidth = 0;
    if (self.screen) {     // for NN4 and IE4
        nWidth = screen.width;
        nHeight = screen.height;
    } else {
        if (self.java) {   // for NN3 with enabled Java
            var jkit = java.awt.Toolkit.getDefaultToolkit();
            var scrsize = jkit.getScreenSize();
            nWidth = scrsize.width;
            nHeight = scrsize.height;
        }
    }
    return nWidth + 'x' + nHeight;
};