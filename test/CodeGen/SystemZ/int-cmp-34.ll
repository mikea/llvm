; Test 64-bit signed comparisons between memory and a constant.
;
; RUN: llc < %s -mtriple=s390x-linux-gnu | FileCheck %s

; Check ordered comparisons with 0.
define double @f1(double %a, double %b, i64 *%ptr) {
; CHECK: f1:
; CHECK: cghsi 0(%r2), 0
; CHECK-NEXT: jl
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, 0
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check ordered comparisons with 1.
define double @f2(double %a, double %b, i64 *%ptr) {
; CHECK: f2:
; CHECK: cghsi 0(%r2), 1
; CHECK-NEXT: jl
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, 1
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check ordered comparisons with the high end of the signed 16-bit range.
define double @f3(double %a, double %b, i64 *%ptr) {
; CHECK: f3:
; CHECK: cghsi 0(%r2), 32767
; CHECK-NEXT: jl
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, 32767
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check the next value up, which can't use CGHSI.
define double @f4(double %a, double %b, i64 *%ptr) {
; CHECK: f4:
; CHECK-NOT: cghsi
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, 32768
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check ordered comparisons with -1.
define double @f5(double %a, double %b, i64 *%ptr) {
; CHECK: f5:
; CHECK: cghsi 0(%r2), -1
; CHECK-NEXT: jl
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, -1
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check ordered comparisons with the low end of the 16-bit signed range.
define double @f6(double %a, double %b, i64 *%ptr) {
; CHECK: f6:
; CHECK: cghsi 0(%r2), -32768
; CHECK-NEXT: jl
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, -32768
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check the next value down, which should be treated as a positive value.
define double @f7(double %a, double %b, i64 *%ptr) {
; CHECK: f7:
; CHECK-NOT: cghsi
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, -32769
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check equality comparisons with 0.
define double @f8(double %a, double %b, i64 *%ptr) {
; CHECK: f8:
; CHECK: cghsi 0(%r2), 0
; CHECK-NEXT: je
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp eq i64 %val, 0
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check equality comparisons with 1.
define double @f9(double %a, double %b, i64 *%ptr) {
; CHECK: f9:
; CHECK: cghsi 0(%r2), 1
; CHECK-NEXT: je
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp eq i64 %val, 1
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check equality comparisons with the high end of the signed 16-bit range.
define double @f10(double %a, double %b, i64 *%ptr) {
; CHECK: f10:
; CHECK: cghsi 0(%r2), 32767
; CHECK-NEXT: je
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp eq i64 %val, 32767
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check the next value up, which can't use CGHSI.
define double @f11(double %a, double %b, i64 *%ptr) {
; CHECK: f11:
; CHECK-NOT: cghsi
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp eq i64 %val, 32768
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check equality comparisons with -1.
define double @f12(double %a, double %b, i64 *%ptr) {
; CHECK: f12:
; CHECK: cghsi 0(%r2), -1
; CHECK-NEXT: je
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp eq i64 %val, -1
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check equality comparisons with the low end of the 16-bit signed range.
define double @f13(double %a, double %b, i64 *%ptr) {
; CHECK: f13:
; CHECK: cghsi 0(%r2), -32768
; CHECK-NEXT: je
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp eq i64 %val, -32768
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check the next value down, which should be treated as a positive value.
define double @f14(double %a, double %b, i64 *%ptr) {
; CHECK: f14:
; CHECK-NOT: cghsi
; CHECK: br %r14
  %val = load i64 *%ptr
  %cond = icmp eq i64 %val, -32769
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check the high end of the CGHSI range.
define double @f15(double %a, double %b, i64 %i1, i64 *%base) {
; CHECK: f15:
; CHECK: cghsi 4088(%r3), 0
; CHECK-NEXT: jl
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %ptr = getelementptr i64 *%base, i64 511
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, 0
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check the next doubleword up, which needs separate address logic,
define double @f16(double %a, double %b, i64 *%base) {
; CHECK: f16:
; CHECK: aghi %r2, 4096
; CHECK: cghsi 0(%r2), 0
; CHECK-NEXT: jl
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %ptr = getelementptr i64 *%base, i64 512
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, 0
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check negative offsets, which also need separate address logic.
define double @f17(double %a, double %b, i64 *%base) {
; CHECK: f17:
; CHECK: aghi %r2, -8
; CHECK: cghsi 0(%r2), 0
; CHECK-NEXT: jl
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %ptr = getelementptr i64 *%base, i64 -1
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, 0
  %res = select i1 %cond, double %a, double %b
  ret double %res
}

; Check that CGHSI does not allow indices.
define double @f18(double %a, double %b, i64 %base, i64 %index) {
; CHECK: f18:
; CHECK: agr {{%r2, %r3|%r3, %r2}}
; CHECK: cghsi 0({{%r[23]}}), 0
; CHECK-NEXT: jl
; CHECK: ldr %f0, %f2
; CHECK: br %r14
  %add = add i64 %base, %index
  %ptr = inttoptr i64 %add to i64 *
  %val = load i64 *%ptr
  %cond = icmp slt i64 %val, 0
  %res = select i1 %cond, double %a, double %b
  ret double %res
}
