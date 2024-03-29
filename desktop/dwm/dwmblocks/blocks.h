//Modify this file to change what commands output to your statusbar, and recompile using the make command.

#define COMMAND(icon, command, interval, signal) {icon, command, NULL, interval, signal}
#define CALLBACK(icon, callback, interval, signal) {icon, NULL, callback, interval, signal}


void mem_callback(char* dest) {

    int x, total, free, buffer, cache, srec, used;
    char l[50];
    FILE* meminfo_file = fopen("/proc/meminfo", "r");
    if (!meminfo_file) {
        sprintf(dest, "RAM: Err");
        return;
    }
    while (!feof(meminfo_file)) {
        fscanf(meminfo_file, "%s %d kB", l, &x);
        if      (!strcmp(l, "MemTotal:"))        total  = x;
        else if (!strcmp(l, "MemFree:"))         free   = x;
        else if (!strcmp(l, "Buffers:"))         buffer = x;
        else if (!strcmp(l, "Cached:"))          cache  = x;
        else if (!strcmp(l, "SReclaimable:"))    srec   = x;
    }
    fclose(meminfo_file);
    used = total - free - buffer - cache - srec;
    used /= 1024;
    sprintf(dest, "RAM: %dMiB", used);

}

void bat_callback(char* dest) {

    int bat_capacity, bat_icon_sel;
    static const char bat_icon[][7] = {"[    ]","[|   ]","[||  ]","[||| ]","[||||]"};
    static const char bat_status_icon[][3] = {"", "="};
    char bat_status[20];
    FILE* bat_capacity_file = fopen("/sys/class/power_supply/BAT0/capacity", "r");
    if (!bat_capacity_file) {
        sprintf(dest, "[!] Err");
        return;
    }
    fscanf(bat_capacity_file, "%d", &bat_capacity);
    fclose(bat_capacity_file);
    FILE* bat_status_file = fopen("/sys/class/power_supply/BAT0/status", "r");
    if (!bat_status_file) {
        sprintf(dest, "[!] Err");
        return;
    }
    fscanf(bat_status_file, "%s", bat_status);
    fclose(bat_status_file);
    bat_icon_sel = (bat_capacity + 13) / 25;
    bat_icon_sel = bat_icon_sel <= 4 ? bat_icon_sel : 4;
    bat_icon_sel = bat_icon_sel >= 0 ? bat_icon_sel : 0;
    sprintf(dest, "BAT: %s  %s %d%%", 
        bat_icon[bat_icon_sel], 
        /* bat_status, */
        bat_status_icon[!strcmp(bat_status, "Charging")], 
        bat_capacity
    );

}

void cputemp_callback(char* dest) {

    int cputemp;
    FILE* cputemp_file = fopen("/sys/class/thermal/thermal_zone0/temp", "r");
    if (!cputemp_file) {
        sprintf(dest, "TEMP: Err");
        return;
    }
    fscanf(cputemp_file, "%d", &cputemp);
    fclose(cputemp_file);
    cputemp /= 1000;
    sprintf(dest, "TEMP: %d°C", cputemp);

}

void cpuload_callback(char* dest) {

    static long int cache_total = 0, cache_active = 0;
    long int new_total, new_active, diff_total, diff_active, cpuload;
    long int r1, r2, r3, r4, r5, r6, r7, r8, r9, r10;
    FILE* stat_file = fopen("/proc/stat", "r");
    if (!stat_file) {
        sprintf(dest, "CPU: Err");
        return;
    }
    fscanf(
        stat_file, 
        "cpu %ld %ld %ld %ld %ld %ld %ld %ld %ld %ld",
        &r1, &r2, &r3, &r4, &r5, &r6, &r7, &r8, &r9, &r10
    );
    fclose(stat_file);
    new_active = r1 + r2 + r3 + r6 + r7 + r8 + r9 + r10;
    new_total = new_active + r4 + r5;
    diff_active = new_active - cache_active;
    diff_total = new_total - cache_total;
    cpuload = (diff_active * 100) / diff_total;
    cache_total = new_total;
    cache_active = new_active;
    sprintf(dest, "CPU: %ld%%", cpuload);

}

void volume_callback(char* dest) {
    
    int vol;
    char vol_mute[48];
    static const char *vol_status_icon[] = {"<x", "<)"};
    FILE* pulse_output = popen("tgd-vol get", "r");
    if (!pulse_output) {
        sprintf(dest, "VOL: <x Err");
        return;
    }
    fscanf(
        pulse_output,
        "{\"volume\": %d, \"mute\": %s}",
        &vol, vol_mute     
    );
    pclose(pulse_output);
    sprintf(dest, "VOL: %s %d%%", vol_status_icon[vol_mute[0] == 'f'], vol);
}

void wifi_callback(char* dest) {

    char iw_output[48];
    static const char *wifi_status_icon[] = {"WIFI: ", "WIFI: "};
    /* FILE* iw_output_file = popen("iwconfig wlp5s0 | awk '/wlp5s0/ { print $4 }' | sed 's/\"//g'", "r"); */
    FILE* iw_output_file = popen("tgd-wifi | jq -r .essid", "r");
    if (!iw_output_file) {
        sprintf(dest, "WIFI: Err");
        return;
    }
    fscanf(iw_output_file, "%s", iw_output);
    pclose(iw_output_file);
    if (strncmp(iw_output, "--", 2)) {
        sprintf(dest, "%s %s", wifi_status_icon[1], iw_output);
    } else {
        sprintf(dest, "%s --", wifi_status_icon[0]);
    }
    
}

static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	/* {"Mem:", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	30,		0}, */

	/* {"", "date '+%b %d (%a) %I:%M%p'",					5,		0}, */
	CALLBACK("",                cpuload_callback,   5, 0),
	CALLBACK("    ",          mem_callback,       5, 0),
	CALLBACK("    ",          cputemp_callback,   7, 0),
	CALLBACK("    ",          wifi_callback,      4, 0),
	CALLBACK("    ",          volume_callback,    3, 10),
	CALLBACK("    ",          bat_callback,       3, 0),
    COMMAND ("    ", "date '+%d %b %y | %H:%M     '", 2, 0),
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " ";
static unsigned int delimLen = 5;
