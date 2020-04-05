#include <stdio.h>

void cm_clk(ARGS)
{
        Digital_State_t *out, *out_old;
        double time_offset = 1.0/(PARAM(freq)*4);

        if (INIT) { /* initial pass */
                cm_event_alloc(0, sizeof(Digital_State_t));
                out = out_old = (Digital_State_t *) cm_event_get_ptr(0, 0);
                STATIC_VAR(last_update) = TIME;
        } else { /* Retrive previous values */
                out = (Digital_State_t *) cm_event_get_ptr(0, 0);
                out_old = (Digital_State_t *) cm_event_get_ptr(0, 1);
        }

        cm_event_queue(TIME + time_offset);
        if (STATIC_VAR(last_update) + time_offset < TIME) {
                STATIC_VAR(last_update) = TIME;
                *out = ZERO;
                if (*out_old == ZERO) {
                        *out = ONE;
                }
        }

        /*** do things depending on analaysis type ***/
        if (ANALYSIS == DC) { /** DC Analysis **/
                OUTPUT_STATE(out) = *out;
        } else { /** Transient Analysis **/
                if (*out != *out_old) {
                        OUTPUT_STATE(out) = *out;
                        OUTPUT_DELAY(out) = 1e-20;
                        OUTPUT_CHANGED(out) = TRUE;
                } else {
                        OUTPUT_CHANGED(out) = FALSE;
                }
        }
        
        OUTPUT_STRENGTH(out) = STRONG;
}
