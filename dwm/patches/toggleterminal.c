void toggleterminal(const Arg *arg) {
    selmon->sel->isterminal = !selmon->sel->isterminal;
    drawbars();
}
