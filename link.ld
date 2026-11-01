/* Memory regions of the mps2-an385 board: AN385, section 3.1, Table 3-1 */
MEMORY
{
    FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 4M
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 4M
}

_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
    .text :
    {
        *(.vector_table)
        *(.text)
    } > FLASH
}
