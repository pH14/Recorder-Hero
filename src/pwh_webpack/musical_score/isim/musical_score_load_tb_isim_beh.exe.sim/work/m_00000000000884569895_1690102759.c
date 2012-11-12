/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x1048c146 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "//vmware-host/Shared Folders/Dropbox/School/MIT 12-13/6.111/Recorder-Hero/src/pwh_webpack/musical_score/musical_score_load.v";
static unsigned int ng1[] = {1722460774U, 0U, 1188966U, 0U, 0U, 0U};
static int ng2[] = {1, 0};
static int ng3[] = {0, 0};
static unsigned int ng4[] = {75U, 0U};
static unsigned int ng5[] = {49U, 0U};
static int ng6[] = {14, 0};
static int ng7[] = {15, 0};
static unsigned int ng8[] = {0U, 0U};
static int ng9[] = {4, 0};
static int ng10[] = {2, 0};
static int ng11[] = {3, 0};
static int ng12[] = {5, 0};
static int ng13[] = {6, 0};
static int ng14[] = {7, 0};
static int ng15[] = {8, 0};
static int ng16[] = {9, 0};
static int ng17[] = {10, 0};
static int ng18[] = {11, 0};
static int ng19[] = {12, 0};
static int ng20[] = {13, 0};



static void NetDecl_29_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    t1 = (t0 + 2536U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(29, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3368);
    t4 = (t3 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    xsi_vlog_bit_copy(t7, 0, t2, 0, 76);
    xsi_driver_vfirst_trans(t3, 0, 75U);

LAB1:    return;
}

static void NetDecl_42_1(char *t0)
{
    char t3[8];
    char t4[8];
    char t9[8];
    char *t1;
    char *t2;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    char *t23;
    char *t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    char *t30;
    char *t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    char *t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    char *t40;
    char *t41;
    char *t42;
    char *t43;
    char *t44;
    char *t45;
    unsigned int t46;
    unsigned int t47;
    char *t48;
    unsigned int t49;
    unsigned int t50;
    char *t51;
    unsigned int t52;
    unsigned int t53;
    char *t54;

LAB0:    t1 = (t0 + 2680U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(42, ng0);
    t2 = (t0 + 1460);
    t5 = (t2 + 36U);
    t6 = *((char **)t5);
    t7 = (t0 + 864U);
    t8 = *((char **)t7);
    memset(t9, 0, 8);
    t7 = (t6 + 4);
    t10 = (t8 + 4);
    t11 = *((unsigned int *)t6);
    t12 = *((unsigned int *)t8);
    t13 = (t11 ^ t12);
    t14 = *((unsigned int *)t7);
    t15 = *((unsigned int *)t10);
    t16 = (t14 ^ t15);
    t17 = (t13 | t16);
    t18 = *((unsigned int *)t7);
    t19 = *((unsigned int *)t10);
    t20 = (t18 | t19);
    t21 = (~(t20));
    t22 = (t17 & t21);
    if (t22 != 0)
        goto LAB7;

LAB4:    if (t20 != 0)
        goto LAB6;

LAB5:    *((unsigned int *)t9) = 1;

LAB7:    memset(t4, 0, 8);
    t24 = (t9 + 4);
    t25 = *((unsigned int *)t24);
    t26 = (~(t25));
    t27 = *((unsigned int *)t9);
    t28 = (t27 & t26);
    t29 = (t28 & 1U);
    if (t29 != 0)
        goto LAB8;

LAB9:    if (*((unsigned int *)t24) != 0)
        goto LAB10;

LAB11:    t31 = (t4 + 4);
    t32 = *((unsigned int *)t4);
    t33 = *((unsigned int *)t31);
    t34 = (t32 || t33);
    if (t34 > 0)
        goto LAB12;

LAB13:    t36 = *((unsigned int *)t4);
    t37 = (~(t36));
    t38 = *((unsigned int *)t31);
    t39 = (t37 || t38);
    if (t39 > 0)
        goto LAB14;

LAB15:    if (*((unsigned int *)t31) > 0)
        goto LAB16;

LAB17:    if (*((unsigned int *)t4) > 0)
        goto LAB18;

LAB19:    memcpy(t3, t40, 8);

LAB20:    t41 = (t0 + 3404);
    t42 = (t41 + 32U);
    t43 = *((char **)t42);
    t44 = (t43 + 40U);
    t45 = *((char **)t44);
    memset(t45, 0, 8);
    t46 = 1U;
    t47 = t46;
    t48 = (t3 + 4);
    t49 = *((unsigned int *)t3);
    t46 = (t46 & t49);
    t50 = *((unsigned int *)t48);
    t47 = (t47 & t50);
    t51 = (t45 + 4);
    t52 = *((unsigned int *)t45);
    *((unsigned int *)t45) = (t52 | t46);
    t53 = *((unsigned int *)t51);
    *((unsigned int *)t51) = (t53 | t47);
    xsi_driver_vfirst_trans(t41, 0, 0U);
    t54 = (t0 + 3308);
    *((int *)t54) = 1;

LAB1:    return;
LAB6:    t23 = (t9 + 4);
    *((unsigned int *)t9) = 1;
    *((unsigned int *)t23) = 1;
    goto LAB7;

LAB8:    *((unsigned int *)t4) = 1;
    goto LAB11;

LAB10:    t30 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t30) = 1;
    goto LAB11;

LAB12:    t35 = ((char*)((ng2)));
    goto LAB13;

LAB14:    t40 = ((char*)((ng3)));
    goto LAB15;

LAB16:    xsi_vlog_unsigned_bit_combine(t3, 32, t35, 32, t40, 32);
    goto LAB20;

LAB18:    memcpy(t3, t35, 8);
    goto LAB20;

}

static void NetDecl_43_2(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;

LAB0:    t1 = (t0 + 2824U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(43, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 3440);
    t4 = (t3 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 40U);
    t7 = *((char **)t6);
    memset(t7, 0, 8);
    t8 = 1U;
    t9 = t8;
    t10 = (t2 + 4);
    t11 = *((unsigned int *)t2);
    t8 = (t8 & t11);
    t12 = *((unsigned int *)t10);
    t9 = (t9 & t12);
    t13 = (t7 + 4);
    t14 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t14 | t8);
    t15 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t15 | t9);
    xsi_driver_vfirst_trans(t3, 0, 0U);

LAB1:    return;
}

static void Always_51_3(char *t0)
{
    char t6[8];
    char t20[8];
    char t27[8];
    char t61[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    char *t19;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    char *t31;
    char *t32;
    char *t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    char *t41;
    char *t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    int t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    char *t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    char *t62;
    char *t63;
    char *t64;
    char *t65;
    char *t66;
    char *t67;
    char *t68;
    int t69;
    int t70;
    int t71;

LAB0:    t1 = (t0 + 2968U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(51, ng0);
    t2 = (t0 + 3316);
    *((int *)t2) = 1;
    t3 = (t0 + 2996);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(51, ng0);

LAB5:    xsi_set_current_line(52, ng0);
    t4 = (t0 + 772U);
    t5 = *((char **)t4);
    memset(t6, 0, 8);
    t4 = (t5 + 4);
    t7 = *((unsigned int *)t4);
    t8 = (~(t7));
    t9 = *((unsigned int *)t5);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB6;

LAB7:    if (*((unsigned int *)t4) != 0)
        goto LAB8;

LAB9:    t13 = (t6 + 4);
    t14 = *((unsigned int *)t6);
    t15 = (!(t14));
    t16 = *((unsigned int *)t13);
    t17 = (t15 || t16);
    if (t17 > 0)
        goto LAB10;

LAB11:    memcpy(t27, t6, 8);

LAB12:    t55 = (t27 + 4);
    t56 = *((unsigned int *)t55);
    t57 = (~(t56));
    t58 = *((unsigned int *)t27);
    t59 = (t58 & t57);
    t60 = (t59 != 0);
    if (t60 > 0)
        goto LAB20;

LAB21:    xsi_set_current_line(55, ng0);
    t2 = (t0 + 1232U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t7 = *((unsigned int *)t2);
    t8 = (~(t7));
    t9 = *((unsigned int *)t3);
    t10 = (t9 & t8);
    t11 = (t10 != 0);
    if (t11 > 0)
        goto LAB24;

LAB25:    xsi_set_current_line(59, ng0);

LAB32:    xsi_set_current_line(60, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 1736);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);

LAB26:
LAB22:    goto LAB2;

LAB6:    *((unsigned int *)t6) = 1;
    goto LAB9;

LAB8:    t12 = (t6 + 4);
    *((unsigned int *)t6) = 1;
    *((unsigned int *)t12) = 1;
    goto LAB9;

LAB10:    t18 = (t0 + 1140U);
    t19 = *((char **)t18);
    memset(t20, 0, 8);
    t18 = (t19 + 4);
    t21 = *((unsigned int *)t18);
    t22 = (~(t21));
    t23 = *((unsigned int *)t19);
    t24 = (t23 & t22);
    t25 = (t24 & 1U);
    if (t25 != 0)
        goto LAB13;

LAB14:    if (*((unsigned int *)t18) != 0)
        goto LAB15;

LAB16:    t28 = *((unsigned int *)t6);
    t29 = *((unsigned int *)t20);
    t30 = (t28 | t29);
    *((unsigned int *)t27) = t30;
    t31 = (t6 + 4);
    t32 = (t20 + 4);
    t33 = (t27 + 4);
    t34 = *((unsigned int *)t31);
    t35 = *((unsigned int *)t32);
    t36 = (t34 | t35);
    *((unsigned int *)t33) = t36;
    t37 = *((unsigned int *)t33);
    t38 = (t37 != 0);
    if (t38 == 1)
        goto LAB17;

LAB18:
LAB19:    goto LAB12;

LAB13:    *((unsigned int *)t20) = 1;
    goto LAB16;

LAB15:    t26 = (t20 + 4);
    *((unsigned int *)t20) = 1;
    *((unsigned int *)t26) = 1;
    goto LAB16;

LAB17:    t39 = *((unsigned int *)t27);
    t40 = *((unsigned int *)t33);
    *((unsigned int *)t27) = (t39 | t40);
    t41 = (t6 + 4);
    t42 = (t20 + 4);
    t43 = *((unsigned int *)t41);
    t44 = (~(t43));
    t45 = *((unsigned int *)t6);
    t46 = (t45 & t44);
    t47 = *((unsigned int *)t42);
    t48 = (~(t47));
    t49 = *((unsigned int *)t20);
    t50 = (t49 & t48);
    t51 = (~(t46));
    t52 = (~(t50));
    t53 = *((unsigned int *)t33);
    *((unsigned int *)t33) = (t53 & t51);
    t54 = *((unsigned int *)t33);
    *((unsigned int *)t33) = (t54 & t52);
    goto LAB19;

LAB20:    xsi_set_current_line(52, ng0);

LAB23:    xsi_set_current_line(53, ng0);
    t62 = (t0 + 1048U);
    t63 = *((char **)t62);
    t62 = (t0 + 1024U);
    t64 = (t62 + 44U);
    t65 = *((char **)t64);
    t66 = ((char*)((ng4)));
    t67 = ((char*)((ng5)));
    xsi_vlog_generic_get_part_select_value(t61, 27, t63, t65, 2, t66, 11U, 2, t67, 32U, 2);
    t68 = (t0 + 1828);
    xsi_vlogvar_wait_assign_value(t68, t61, 0, 0, 26, 0LL);
    xsi_set_current_line(54, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 1736);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB22;

LAB24:    xsi_set_current_line(55, ng0);

LAB27:    xsi_set_current_line(56, ng0);
    t4 = (t0 + 2012);
    t5 = (t4 + 36U);
    t12 = *((char **)t5);
    t13 = (t0 + 2012);
    t18 = (t13 + 44U);
    t19 = *((char **)t18);
    t26 = (t0 + 2012);
    t31 = (t26 + 40U);
    t32 = *((char **)t31);
    t33 = ((char*)((ng6)));
    xsi_vlog_generic_get_array_select_value(t6, 4, t12, t19, t32, 2, 1, t33, 32, 1);
    t41 = (t0 + 2012);
    t42 = (t0 + 2012);
    t55 = (t42 + 44U);
    t62 = *((char **)t55);
    t63 = (t0 + 2012);
    t64 = (t63 + 40U);
    t65 = *((char **)t64);
    t66 = ((char*)((ng7)));
    xsi_vlog_generic_convert_array_indices(t20, t27, t62, t65, 2, 1, t66, 32, 1);
    t67 = (t20 + 4);
    t14 = *((unsigned int *)t67);
    t46 = (!(t14));
    t68 = (t27 + 4);
    t15 = *((unsigned int *)t68);
    t50 = (!(t15));
    t69 = (t46 && t50);
    if (t69 == 1)
        goto LAB28;

LAB29:    xsi_set_current_line(57, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 2012);
    t4 = (t0 + 2012);
    t5 = (t4 + 44U);
    t12 = *((char **)t5);
    t13 = (t0 + 2012);
    t18 = (t13 + 40U);
    t19 = *((char **)t18);
    t26 = ((char*)((ng3)));
    xsi_vlog_generic_convert_array_indices(t6, t20, t12, t19, 2, 1, t26, 32, 1);
    t31 = (t6 + 4);
    t7 = *((unsigned int *)t31);
    t46 = (!(t7));
    t32 = (t20 + 4);
    t8 = *((unsigned int *)t32);
    t50 = (!(t8));
    t69 = (t46 && t50);
    if (t69 == 1)
        goto LAB30;

LAB31:    xsi_set_current_line(58, ng0);
    t2 = (t0 + 1920);
    t3 = (t2 + 36U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng9)));
    memset(t6, 0, 8);
    xsi_vlog_unsigned_minus(t6, 32, t4, 11, t5, 32);
    t12 = (t0 + 1920);
    xsi_vlogvar_wait_assign_value(t12, t6, 0, 0, 11, 0LL);
    goto LAB26;

LAB28:    t16 = *((unsigned int *)t20);
    t17 = *((unsigned int *)t27);
    t70 = (t16 - t17);
    t71 = (t70 + 1);
    xsi_vlogvar_wait_assign_value(t41, t6, 0, *((unsigned int *)t27), t71, 0LL);
    goto LAB29;

LAB30:    t9 = *((unsigned int *)t6);
    t10 = *((unsigned int *)t20);
    t70 = (t9 - t10);
    t71 = (t70 + 1);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, *((unsigned int *)t20), t71, 0LL);
    goto LAB31;

}

static void Cont_64_4(char *t0)
{
    char t3[16];
    char t6[8];
    char t17[8];
    char t28[8];
    char t39[8];
    char t50[8];
    char t61[8];
    char t72[8];
    char t83[8];
    char t94[8];
    char t105[8];
    char t116[8];
    char t127[8];
    char t138[8];
    char t149[8];
    char t160[8];
    char t171[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;
    char *t36;
    char *t37;
    char *t38;
    char *t40;
    char *t41;
    char *t42;
    char *t43;
    char *t44;
    char *t45;
    char *t46;
    char *t47;
    char *t48;
    char *t49;
    char *t51;
    char *t52;
    char *t53;
    char *t54;
    char *t55;
    char *t56;
    char *t57;
    char *t58;
    char *t59;
    char *t60;
    char *t62;
    char *t63;
    char *t64;
    char *t65;
    char *t66;
    char *t67;
    char *t68;
    char *t69;
    char *t70;
    char *t71;
    char *t73;
    char *t74;
    char *t75;
    char *t76;
    char *t77;
    char *t78;
    char *t79;
    char *t80;
    char *t81;
    char *t82;
    char *t84;
    char *t85;
    char *t86;
    char *t87;
    char *t88;
    char *t89;
    char *t90;
    char *t91;
    char *t92;
    char *t93;
    char *t95;
    char *t96;
    char *t97;
    char *t98;
    char *t99;
    char *t100;
    char *t101;
    char *t102;
    char *t103;
    char *t104;
    char *t106;
    char *t107;
    char *t108;
    char *t109;
    char *t110;
    char *t111;
    char *t112;
    char *t113;
    char *t114;
    char *t115;
    char *t117;
    char *t118;
    char *t119;
    char *t120;
    char *t121;
    char *t122;
    char *t123;
    char *t124;
    char *t125;
    char *t126;
    char *t128;
    char *t129;
    char *t130;
    char *t131;
    char *t132;
    char *t133;
    char *t134;
    char *t135;
    char *t136;
    char *t137;
    char *t139;
    char *t140;
    char *t141;
    char *t142;
    char *t143;
    char *t144;
    char *t145;
    char *t146;
    char *t147;
    char *t148;
    char *t150;
    char *t151;
    char *t152;
    char *t153;
    char *t154;
    char *t155;
    char *t156;
    char *t157;
    char *t158;
    char *t159;
    char *t161;
    char *t162;
    char *t163;
    char *t164;
    char *t165;
    char *t166;
    char *t167;
    char *t168;
    char *t169;
    char *t170;
    char *t172;
    char *t173;
    char *t174;
    char *t175;
    char *t176;
    char *t177;
    char *t178;
    char *t179;
    char *t180;
    char *t181;
    char *t182;
    char *t183;
    char *t184;

LAB0:    t1 = (t0 + 3112U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(64, ng0);
    t2 = (t0 + 2012);
    t4 = (t2 + 36U);
    t5 = *((char **)t4);
    t7 = (t0 + 2012);
    t8 = (t7 + 44U);
    t9 = *((char **)t8);
    t10 = (t0 + 2012);
    t11 = (t10 + 40U);
    t12 = *((char **)t11);
    t13 = ((char*)((ng3)));
    xsi_vlog_generic_get_array_select_value(t6, 4, t5, t9, t12, 2, 1, t13, 32, 1);
    t14 = (t0 + 2012);
    t15 = (t14 + 36U);
    t16 = *((char **)t15);
    t18 = (t0 + 2012);
    t19 = (t18 + 44U);
    t20 = *((char **)t19);
    t21 = (t0 + 2012);
    t22 = (t21 + 40U);
    t23 = *((char **)t22);
    t24 = ((char*)((ng2)));
    xsi_vlog_generic_get_array_select_value(t17, 4, t16, t20, t23, 2, 1, t24, 32, 1);
    t25 = (t0 + 2012);
    t26 = (t25 + 36U);
    t27 = *((char **)t26);
    t29 = (t0 + 2012);
    t30 = (t29 + 44U);
    t31 = *((char **)t30);
    t32 = (t0 + 2012);
    t33 = (t32 + 40U);
    t34 = *((char **)t33);
    t35 = ((char*)((ng10)));
    xsi_vlog_generic_get_array_select_value(t28, 4, t27, t31, t34, 2, 1, t35, 32, 1);
    t36 = (t0 + 2012);
    t37 = (t36 + 36U);
    t38 = *((char **)t37);
    t40 = (t0 + 2012);
    t41 = (t40 + 44U);
    t42 = *((char **)t41);
    t43 = (t0 + 2012);
    t44 = (t43 + 40U);
    t45 = *((char **)t44);
    t46 = ((char*)((ng11)));
    xsi_vlog_generic_get_array_select_value(t39, 4, t38, t42, t45, 2, 1, t46, 32, 1);
    t47 = (t0 + 2012);
    t48 = (t47 + 36U);
    t49 = *((char **)t48);
    t51 = (t0 + 2012);
    t52 = (t51 + 44U);
    t53 = *((char **)t52);
    t54 = (t0 + 2012);
    t55 = (t54 + 40U);
    t56 = *((char **)t55);
    t57 = ((char*)((ng9)));
    xsi_vlog_generic_get_array_select_value(t50, 4, t49, t53, t56, 2, 1, t57, 32, 1);
    t58 = (t0 + 2012);
    t59 = (t58 + 36U);
    t60 = *((char **)t59);
    t62 = (t0 + 2012);
    t63 = (t62 + 44U);
    t64 = *((char **)t63);
    t65 = (t0 + 2012);
    t66 = (t65 + 40U);
    t67 = *((char **)t66);
    t68 = ((char*)((ng12)));
    xsi_vlog_generic_get_array_select_value(t61, 4, t60, t64, t67, 2, 1, t68, 32, 1);
    t69 = (t0 + 2012);
    t70 = (t69 + 36U);
    t71 = *((char **)t70);
    t73 = (t0 + 2012);
    t74 = (t73 + 44U);
    t75 = *((char **)t74);
    t76 = (t0 + 2012);
    t77 = (t76 + 40U);
    t78 = *((char **)t77);
    t79 = ((char*)((ng13)));
    xsi_vlog_generic_get_array_select_value(t72, 4, t71, t75, t78, 2, 1, t79, 32, 1);
    t80 = (t0 + 2012);
    t81 = (t80 + 36U);
    t82 = *((char **)t81);
    t84 = (t0 + 2012);
    t85 = (t84 + 44U);
    t86 = *((char **)t85);
    t87 = (t0 + 2012);
    t88 = (t87 + 40U);
    t89 = *((char **)t88);
    t90 = ((char*)((ng14)));
    xsi_vlog_generic_get_array_select_value(t83, 4, t82, t86, t89, 2, 1, t90, 32, 1);
    t91 = (t0 + 2012);
    t92 = (t91 + 36U);
    t93 = *((char **)t92);
    t95 = (t0 + 2012);
    t96 = (t95 + 44U);
    t97 = *((char **)t96);
    t98 = (t0 + 2012);
    t99 = (t98 + 40U);
    t100 = *((char **)t99);
    t101 = ((char*)((ng15)));
    xsi_vlog_generic_get_array_select_value(t94, 4, t93, t97, t100, 2, 1, t101, 32, 1);
    t102 = (t0 + 2012);
    t103 = (t102 + 36U);
    t104 = *((char **)t103);
    t106 = (t0 + 2012);
    t107 = (t106 + 44U);
    t108 = *((char **)t107);
    t109 = (t0 + 2012);
    t110 = (t109 + 40U);
    t111 = *((char **)t110);
    t112 = ((char*)((ng16)));
    xsi_vlog_generic_get_array_select_value(t105, 4, t104, t108, t111, 2, 1, t112, 32, 1);
    t113 = (t0 + 2012);
    t114 = (t113 + 36U);
    t115 = *((char **)t114);
    t117 = (t0 + 2012);
    t118 = (t117 + 44U);
    t119 = *((char **)t118);
    t120 = (t0 + 2012);
    t121 = (t120 + 40U);
    t122 = *((char **)t121);
    t123 = ((char*)((ng17)));
    xsi_vlog_generic_get_array_select_value(t116, 4, t115, t119, t122, 2, 1, t123, 32, 1);
    t124 = (t0 + 2012);
    t125 = (t124 + 36U);
    t126 = *((char **)t125);
    t128 = (t0 + 2012);
    t129 = (t128 + 44U);
    t130 = *((char **)t129);
    t131 = (t0 + 2012);
    t132 = (t131 + 40U);
    t133 = *((char **)t132);
    t134 = ((char*)((ng18)));
    xsi_vlog_generic_get_array_select_value(t127, 4, t126, t130, t133, 2, 1, t134, 32, 1);
    t135 = (t0 + 2012);
    t136 = (t135 + 36U);
    t137 = *((char **)t136);
    t139 = (t0 + 2012);
    t140 = (t139 + 44U);
    t141 = *((char **)t140);
    t142 = (t0 + 2012);
    t143 = (t142 + 40U);
    t144 = *((char **)t143);
    t145 = ((char*)((ng19)));
    xsi_vlog_generic_get_array_select_value(t138, 4, t137, t141, t144, 2, 1, t145, 32, 1);
    t146 = (t0 + 2012);
    t147 = (t146 + 36U);
    t148 = *((char **)t147);
    t150 = (t0 + 2012);
    t151 = (t150 + 44U);
    t152 = *((char **)t151);
    t153 = (t0 + 2012);
    t154 = (t153 + 40U);
    t155 = *((char **)t154);
    t156 = ((char*)((ng20)));
    xsi_vlog_generic_get_array_select_value(t149, 4, t148, t152, t155, 2, 1, t156, 32, 1);
    t157 = (t0 + 2012);
    t158 = (t157 + 36U);
    t159 = *((char **)t158);
    t161 = (t0 + 2012);
    t162 = (t161 + 44U);
    t163 = *((char **)t162);
    t164 = (t0 + 2012);
    t165 = (t164 + 40U);
    t166 = *((char **)t165);
    t167 = ((char*)((ng6)));
    xsi_vlog_generic_get_array_select_value(t160, 4, t159, t163, t166, 2, 1, t167, 32, 1);
    t168 = (t0 + 2012);
    t169 = (t168 + 36U);
    t170 = *((char **)t169);
    t172 = (t0 + 2012);
    t173 = (t172 + 44U);
    t174 = *((char **)t173);
    t175 = (t0 + 2012);
    t176 = (t175 + 40U);
    t177 = *((char **)t176);
    t178 = ((char*)((ng7)));
    xsi_vlog_generic_get_array_select_value(t171, 4, t170, t174, t177, 2, 1, t178, 32, 1);
    xsi_vlogtype_concat(t3, 64, 64, 16U, t171, 4, t160, 4, t149, 4, t138, 4, t127, 4, t116, 4, t105, 4, t94, 4, t83, 4, t72, 4, t61, 4, t50, 4, t39, 4, t28, 4, t17, 4, t6, 4);
    t179 = (t0 + 3476);
    t180 = (t179 + 32U);
    t181 = *((char **)t180);
    t182 = (t181 + 40U);
    t183 = *((char **)t182);
    xsi_vlog_bit_copy(t183, 0, t3, 0, 16);
    xsi_driver_vfirst_trans(t179, 0, 15);
    t184 = (t0 + 3324);
    *((int *)t184) = 1;

LAB1:    return;
}


extern void work_m_00000000000884569895_1690102759_init()
{
	static char *pe[] = {(void *)NetDecl_29_0,(void *)NetDecl_42_1,(void *)NetDecl_43_2,(void *)Always_51_3,(void *)Cont_64_4};
	xsi_register_didat("work_m_00000000000884569895_1690102759", "isim/musical_score_load_tb_isim_beh.exe.sim/work/m_00000000000884569895_1690102759.didat");
	xsi_register_executes(pe);
}
