//Modify this file to change what commands output to your statusbar, and recompile using the make command.

// Accepts sstring as command
#define COMMAND(icon, command, interval, signal) {icon, command, NULL, interval, signal}
// Accepts function as callback
#define CALLBACK(icon, callback, interval, signal) {icon, NULL, callback, interval, signal}

// Example callback for memory
void mem_callback(char* dest) {

	int x, total, free, buffer, cache, srec, used;
	char l[50];
	FILE* meminfo_file = fopen("/proc/meminfo", "r");
	if (!meminfo_file) {
		sprintf(dest, " Err");
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
	sprintf(dest, " %dMiB", used);

}

static const Block blocks[] = {
	CALLBACK("", mem_callback, 7, 0),
	COMMAND (";", "date '+%A, %d %B %Y | %H:%M'", 2, 0),
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
