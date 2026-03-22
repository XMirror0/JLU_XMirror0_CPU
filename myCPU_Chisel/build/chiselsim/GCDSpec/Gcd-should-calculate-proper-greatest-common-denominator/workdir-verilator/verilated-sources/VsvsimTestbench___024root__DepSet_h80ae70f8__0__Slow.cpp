// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VsvsimTestbench.h for the primary calling header

#include "VsvsimTestbench__pch.h"
#include "VsvsimTestbench___024root.h"

VL_ATTR_COLD void VsvsimTestbench___024root___eval_static__TOP(VsvsimTestbench___024root* vlSelf);

VL_ATTR_COLD void VsvsimTestbench___024root___eval_static(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___eval_static\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VsvsimTestbench___024root___eval_static__TOP(vlSelf);
}

VL_ATTR_COLD void VsvsimTestbench___024root___eval_static__TOP(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___eval_static__TOP\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.svsimTestbench__DOT__clock = 0U;
    vlSelfRef.svsimTestbench__DOT__reset = 0U;
    vlSelfRef.svsimTestbench__DOT__input_bits_value2 = 0U;
    vlSelfRef.svsimTestbench__DOT__input_bits_value1 = 0U;
    vlSelfRef.svsimTestbench__DOT__input_valid = 0U;
    vlSelfRef.svsimTestbench__DOT__output_ready = 0U;
    vlSelfRef.svsimTestbench__DOT__simulationState = 0U;
}

VL_ATTR_COLD void VsvsimTestbench___024root___eval_initial__TOP(VsvsimTestbench___024root* vlSelf);

VL_ATTR_COLD void VsvsimTestbench___024root___eval_initial(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___eval_initial\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VsvsimTestbench___024root___eval_initial__TOP(vlSelf);
    vlSelfRef.__Vtrigprevexpr___TOP__svsimTestbench__DOT__simulationState__0 = 1U;
    vlSelfRef.__Vtrigprevexpr___TOP__svsimTestbench__DOT__clock__0 
        = vlSelfRef.svsimTestbench__DOT__clock;
}

VL_ATTR_COLD void VsvsimTestbench___024root___eval_final__TOP(VsvsimTestbench___024root* vlSelf);

VL_ATTR_COLD void VsvsimTestbench___024root___eval_final(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___eval_final\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VsvsimTestbench___024root___eval_final__TOP(vlSelf);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void VsvsimTestbench___024root___dump_triggers__stl(VsvsimTestbench___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool VsvsimTestbench___024root___eval_phase__stl(VsvsimTestbench___024root* vlSelf);

VL_ATTR_COLD void VsvsimTestbench___024root___eval_settle(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___eval_settle\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY((0x64U < __VstlIterCount))) {
#ifdef VL_DEBUG
            VsvsimTestbench___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("/home/cooper/Code/Chisel/chisel-template/build/chiselsim/GCDSpec/Gcd-should-calculate-proper-greatest-common-denominator/workdir-verilator/../generated-sources/testbench.sv", 1, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (VsvsimTestbench___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void VsvsimTestbench___024root___dump_triggers__stl(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___dump_triggers__stl\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void VsvsimTestbench___024root___stl_sequent__TOP__0(VsvsimTestbench___024root* vlSelf);

VL_ATTR_COLD void VsvsimTestbench___024root___eval_stl(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___eval_stl\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VsvsimTestbench___024root___stl_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void VsvsimTestbench___024root___stl_sequent__TOP__0(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___stl_sequent__TOP__0\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.svsimTestbench__DOT__dut__DOT___GEN = 
        (0U == (IData)(vlSelfRef.svsimTestbench__DOT__dut__DOT__x));
}

VL_ATTR_COLD void VsvsimTestbench___024root___eval_triggers__stl(VsvsimTestbench___024root* vlSelf);

VL_ATTR_COLD bool VsvsimTestbench___024root___eval_phase__stl(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___eval_phase__stl\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    VsvsimTestbench___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        VsvsimTestbench___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void VsvsimTestbench___024root___dump_triggers__act(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___dump_triggers__act\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: Internal 'act' trigger - DPI export trigger\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @([changed] svsimTestbench.simulationState)\n");
    }
    if ((4ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 2 is active: @(posedge svsimTestbench.clock)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void VsvsimTestbench___024root___dump_triggers__nba(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___dump_triggers__nba\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: Internal 'nba' trigger - DPI export trigger\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @([changed] svsimTestbench.simulationState)\n");
    }
    if ((4ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 2 is active: @(posedge svsimTestbench.clock)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void VsvsimTestbench___024root___ctor_var_reset(VsvsimTestbench___024root* vlSelf) {
    (void)vlSelf;  // Prevent unused variable warning
    VsvsimTestbench__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VsvsimTestbench___024root___ctor_var_reset\n"); );
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->svsimTestbench__DOT__clock = VL_RAND_RESET_I(1);
    vlSelf->svsimTestbench__DOT__reset = VL_RAND_RESET_I(1);
    vlSelf->svsimTestbench__DOT__input_bits_value2 = VL_RAND_RESET_I(16);
    vlSelf->svsimTestbench__DOT__input_bits_value1 = VL_RAND_RESET_I(16);
    vlSelf->svsimTestbench__DOT__input_valid = VL_RAND_RESET_I(1);
    vlSelf->svsimTestbench__DOT__output_ready = VL_RAND_RESET_I(1);
    vlSelf->svsimTestbench__DOT__simulationState = 0;
    vlSelf->svsimTestbench__DOT__dut__DOT__xInitial = VL_RAND_RESET_I(16);
    vlSelf->svsimTestbench__DOT__dut__DOT__yInitial = VL_RAND_RESET_I(16);
    vlSelf->svsimTestbench__DOT__dut__DOT__x = VL_RAND_RESET_I(16);
    vlSelf->svsimTestbench__DOT__dut__DOT__y = VL_RAND_RESET_I(16);
    vlSelf->svsimTestbench__DOT__dut__DOT__busy = VL_RAND_RESET_I(1);
    vlSelf->svsimTestbench__DOT__dut__DOT__resultValid = VL_RAND_RESET_I(1);
    vlSelf->svsimTestbench__DOT__dut__DOT___GEN = VL_RAND_RESET_I(1);
    vlSelf->svsimTestbench__DOT__dut__DOT__unnamedblk1__DOT___GEN_0 = VL_RAND_RESET_I(1);
    vlSelf->svsimTestbench__DOT__dut__DOT__unnamedblk1__DOT___GEN_1 = VL_RAND_RESET_I(1);
    for (int __Vi0 = 0; __Vi0 < 3; ++__Vi0) {
        vlSelf->svsimTestbench__DOT__dut__DOT__unnamedblk2__DOT___RANDOM[__Vi0] = VL_RAND_RESET_I(32);
    }
    vlSelf->__Vdpi_export_trigger = 0;
    vlSelf->__Vtrigprevexpr___TOP__svsimTestbench__DOT__simulationState__0 = 0;
    vlSelf->__Vtrigprevexpr___TOP__svsimTestbench__DOT__clock__0 = VL_RAND_RESET_I(1);
    vlSelf->__VactDidInit = 0;
}
