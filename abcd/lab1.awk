BEGIN {
	count=0;
}
{
if ($1=="d")
count++;
}
END {
	printf("Dropped packets: %d\n\n", count);
}
