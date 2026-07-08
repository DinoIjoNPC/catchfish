([[This file was protected with MoonSec V3]]):gsub(
    ".+",
    (function(a)
        _cJbkrIuAqMMw = a
    end)
)
return (function(o, ...)
    local s
    local f
    local r
    local t
    local a
    local d
    local e = 24915
    local n = 0
    local l = {}
    while n < 591 do
        n = n + 1
        while n < 0xa0 and e % 0x4040 < 0x2020 do
            n = n + 1
            e = (e + 166) % 38521
            local h = n + e
            if (e % 0x2dce) > 0x16e7 then
                e = (e - 0x1d5) % 0x3ec3
                while n < 0x2a0 and e % 0x1068 < 0x834 do
                    n = n + 1
                    e = (e - 44) % 43298
                    local h = n + e
                    if (e % 0x996) <= 0x4cb then
                        e = (e * 0x6c) % 0x51f3
                        local e = 31141
                        if not l[e] then
                            l[e] = 0x1
                            s = tonumber
                        end
                    elseif e % 2 ~= 0 then
                        e = (e * 0x2dc) % 0xace7
                        local e = 1776
                        if not l[e] then
                            l[e] = 0x1
                            r =
                                "\4\8\116\111\110\117\109\98\101\114\105\95\90\109\122\76\95\77\0\6\115\116\114\105\110\103\4\99\104\97\114\74\82\72\97\98\106\97\66\0\6\115\116\114\105\110\103\3\115\117\98\107\121\113\90\84\104\111\70\0\6\115\116\114\105\110\103\4\98\121\116\101\88\87\101\121\106\76\83\73\0\5\116\97\98\108\101\6\99\111\110\99\97\116\116\66\82\90\76\116\85\79\0\5\116\97\98\108\101\6\105\110\115\101\114\116\105\76\83\74\89\73\70\95\5"
                        end
                    else
                        e = (e - 0x11d) % 0xa491
                        n = n + 1
                        local e = 71340
                        if not l[e] then
                            l[e] = 0x1
                            t = function(l)
                                local e = 0x01
                                local function n(n)
                                    e = e + n
                                    return l:sub(e - n, e - 0x01)
                                end
                                while true do
                                    local l = n(0x01)
                                    if (l == "\5") then
                                        break
                                    end
                                    local e = f.byte(n(0x01))
                                    local e = n(e)
                                    if l == "\2" then
                                        e = a.i_ZmzL_M(e)
                                    elseif l == "\3" then
                                        e = e ~= "\0"
                                    elseif l == "\6" then
                                        d[e] = function(e, n)
                                            return o(8, nil, o, n, e)
                                        end
                                    elseif l == "\4" then
                                        e = d[e]
                                    elseif l == "\0" then
                                        e = d[e][n(f.byte(n(0x01)))]
                                    end
                                    local n = n(0x08)
                                    a[n] = e
                                end
                            end
                        end
                    end
                end
            elseif e % 2 ~= 0 then
                e = (e - 0x70) % 0xb16c
                while n < 0x2ac and e % 0x42fc < 0x217e do
                    n = n + 1
                    e = (e * 636) % 24987
                    local t = n + e
                    if (e % 0x2de8) > 0x16f4 then
                        e = (e + 0x71) % 0x732a
                        local e = 31952
                        if not l[e] then
                            l[e] = 0x1
                            a = {}
                        end
                    elseif e % 2 ~= 0 then
                        e = (e - 0x399) % 0x3ae0
                        local e = 26212
                        if not l[e] then
                            l[e] = 0x1
                            d = getfenv and getfenv()
                        end
                    else
                        e = (e * 0x2ec) % 0x6423
                        n = n + 1
                        local e = 48041
                        if not l[e] then
                            l[e] = 0x1
                            f = string
                        end
                    end
                end
            else
                e = (e * 0x382) % 0x69f7
                n = n + 1
                while n < 0x125 and e % 0xc54 < 0x62a do
                    n = n + 1
                    e = (e * 376) % 6152
                    local t = n + e
                    if (e % 0x3fc0) <= 0x1fe0 then
                        e = (e - 0x2a2) % 0xae69
                        local e = 61510
                        if not l[e] then
                            l[e] = 0x1
                            d = (not d) and _ENV or d
                        end
                    elseif e % 2 ~= 0 then
                        e = (e - 0x146) % 0x747e
                        local e = 59078
                        if not l[e] then
                            l[e] = 0x1
                        end
                    else
                        e = (e - 0x110) % 0x7787
                        n = n + 1
                        local e = 54235
                        if not l[e] then
                            l[e] = 0x1
                        end
                    end
                end
            end
        end
        e = (e * 489) % 6646
    end
    t(r)
    local e = {}
    for n = 0x0, 0xff do
        local l = a.JRHabjaB(n)
        e[n] = l
        e[l] = n
    end
    local function h(n)
        return e[n]
    end
    local l = (function(f, o)
        local r, l = 0x01, 0x10
        local n = {{}, {}, {}}
        local d = -0x01
        local e = 0x01
        local t = f
        while true do
            n[0x03][
                    a.kyqZThoF(
                        o,
                        e,
                        (function()
                            e = r + e
                            return e - 0x01
                        end)()
                    )
                ] = (function()
                d = d + 0x01
                return d
            end)()
            if d == (0x0f) then
                d = ""
                l = 0x000
                break
            end
        end
        local d = #o
        while e < d + 0x01 do
            n[0x02][l] =
                a.kyqZThoF(
                o,
                e,
                (function()
                    e = r + e
                    return e - 0x01
                end)()
            )
            l = l + 0x01
            if l % 0x02 == 0x00 then
                l = 0x00
                a.iLSJYIF_(
                    n[0x01],
                    (h((((n[0x03][n[0x02][0x00]] or 0x00) * 0x10) + (n[0x03][n[0x02][0x01]] or 0x00) + t) % 0x100))
                )
                t = f + t
            end
        end
        return a.tBRZLtUO(n[0x01])
    end)
    t(l(152, "kl59D4&ci0w/1U8_&U"))
    t(
        l(
            110,
            "3B?g%whHJU(M_dG5U??(?UM_%_dwh_5H?hBJMM%wd(gddwJdBGJU?(_?%dUr?g?z(wgwd?h%G%HgB_Jw?%(_%wdUBMMB(G%?_Mh?5(JMBdH5BB(BgUGUHo(J%bg5d?h?GMJ?qdgdgHMdh?GgH(GHUMgB(5gU_?wwfwg%_(_w%M5=Hh(wUG?JMMh;G(h5BgHHig_hwBGwHh(fg(ggMHwJGghdYGJdg?MB%%GihMG5HBgg(B?JG_HGBa?__B(?%gdgHh:gUJGMJM?5_dhHdhJd5MUMdGHoHw5BJM?JMB%BMghM5%hU=JM%dJhUggd%UJa)UM?H(5g_5d?fMhM%%BdHh(5(JgB((wBJd_hUGdh_BGUB%whE5H5JHHm((hgBh%hw5WJ%SHUMgwMGhg5?w(GJ(J?Mdg5fJ%JwBt(%?HMMww_5hH5%JggUUdhBG(B#(g(ng%Mdw%G_wh!gHG?5UMg%_wwBUGg?gBMw%GdUhUj_HB}JUB?__BHdd(h(M(wQ%MdBHh5_?MBGMh%MddH?G(JJ,_(H%?dJ%%Gw?H"
        )
    )
    local e =
        (-103 +
        (function()
            local l, n = 0, 1
            (function(e)
                e(e(e))
            end)(
                function(e)
                    if l > 195 then
                        return e
                    end
                    l = l + 1
                    n = (n - 937) % 26001
                    if (n % 220) <= 110 then
                        n = (n - 682) % 17578
                        return e
                    else
                        return e(e(e))
                    end
                    return e(e(e))
                end
            )
            return n
        end)())
    local u = a.SYTQuGyp or a.burHDrcy
    local le = (getfenv) or (function()
            return _ENV
        end)
    local d = 2
    local ne = 1
    local t = 3
    local h = 4
    local function m(b, ...)
        local r =
            l(
            e,
            "3&-M5KBUQF 9Tp(aF-,(FK&T KM59&MQ9a9-MT9KMapKKp(-B8(TBTQ(&9F -& QQ5-F -MB9FMMTB5KBFBUUKaTQMU->KQTeaFF(UBM(  BM-TMM TpKUpV-&ppUOaKM(aUQpVpK -FF(-- aMpT55UpB&F -- 9BMU9a5 TaK5pFBM(QB(a(Qr=BF&&BF9-& KK09TKpc5U-DMBaa&Q5&BF9M99{Kip-&((KKK9p5MlMQB(BB5zaB(aKQ-aM9M&DTBKM U-MpFMaa&UaapQU(9BapT *RUQ MOTK5FpM-Qp-M-TU5M9(Q-oUQa&UFK(KQp&T QMM Tp9BU(UB(aKT5UUa(Q&paQ5& -aT&M9T-5FMFTT5BpKK(pTBa(FUQR&Ua&-FB pKF9F5VTU -MpTKKBQ KU(&B9(9-p)9UT&K5F-J F-p9FM&9B5(TB5TQaBp(BUQaMM-(BQa&BFTnQ &-BB -UQ9(& U(pU5a9( UpX5QU&&Kap9B--T -MaUpMpTBKQpMBUp9UKa UM:UUa&-FQ-KFp-p9 a99U5 Ta&Q( KQ(&Bpa&QJ&5QFDp --  T-a9559QQKQFBK9pBBKa&MF6&Q9pQKap9 cM< MT9K5pUK((KpMK5(UBBQ &BFB&p 5Q-&UF9-Q9BMpT:p(UT( U&aQTTUKaTQ-((QU)TQaj 9-MU9K5&T&K59iKQp B&(FUFpMQp&5FF9R5-9T5MT 9gM9 F5QpQBBT5UUT Q&(5B9&T-T9MM T&5Q(-KBppB5(9U-aFQbDUQa&KFT-M9T5l9QMaTBKUp5K9(-U9apUUa(QK&UFM&  &5(9aMB9p55p&K-p Bh(pB(aFQUNMQ &&F(&a U-p9Q5BT-5Fp*K(p(BB(TUMoBQ&DQQa&UFp-5 955TF5*TU5(p KT(MB rMQKaaQBnpFB&9 --FT-5 9(5KTTKBp B&(QQ&aTUp,5Q9&9FF-8 U5{T(MTTM5 p-KQpaBBaaQTa9QMJFFQ&UF(-KTTMQ9 5-TQKkpBB&(5UpY UFvMQU&KFK&T M- T5MQTq5BpJK5p9B-(FUMaUU(jKQT&MFT-& QM59BMpT55Tp-K (*BUa-UKaTQM_9F&&QFa"
        )
        local n = 0
        a.ZWnERHOQ(
            function()
                a.kiIofIVp()
                n = n + 1
            end
        )
        local function e(e, l)
            if l then
                return n
            end
            n = e + n
        end
        local l, n, c = o(0, o, e, r, a.XWeyjLSI)
        local function f()
            local n, l = a.XWeyjLSI(r, e(1, 3), e(5, 6) + 2)
            e(2)
            return (l * 256) + n
        end
        local p = true
        local p = 0
        local function g()
            local d = n()
            local e = n()
            local t = 1
            local d = (l(e, 1, 20) * (2 ^ 32)) + d
            local n = l(e, 21, 31)
            local e = ((-1) ^ l(e, 32))
            if (n == 0) then
                if (d == p) then
                    return e * 0
                else
                    n = 1
                    t = 0
                end
            elseif (n == 2047) then
                return (d == 0) and (e * (1 / 0)) or (e * (0 / 0))
            end
            return a.cuGArkml(e, n - 1023) * (t + (d / (2 ^ 52)))
        end
        local _ = n
        local function k(n)
            local l
            if (not n) then
                n = _()
                if (n == 0) then
                    return ""
                end
            end
            l = a.kyqZThoF(r, e(1, 3), e(5, 6) + n - 1)
            e(n)
            local e = ""
            for n = (1 + p), #l do
                e = e .. a.kyqZThoF(l, n, n)
            end
            return e
        end
        local p = #a.HzugTtUw(s("\49.\48")) ~= 1
        local e = n
        local function j(...)
            return {...}, a.GLCLOyDB("#", ...)
        end
        local function m()
            local e = {}
            local u = {}
            local o = {}
            local s = {u, o, nil, e}
            local e = n()
            local r = {}
            for d = 1, e do
                local l = c()
                local n
                if (l == 0) then
                    n = (c() ~= #{})
                elseif (l == 1) then
                    local e = g()
                    if p and a.CeiUMDEc(a.HzugTtUw(e), ".(\48+)$") then
                        e = a.XdV_hlFU(e)
                    end
                    n = e
                elseif (l == 2) then
                    n = k()
                end
                r[d] = n
            end
            s[3] = c()
            for e = 1, n() do
                o[e - (#{1})] = m()
            end
            for s = 1, n() do
                local e = c()
                if (l(e, 1, 1) == 0) then
                    local o = l(e, 2, 3)
                    local a = l(e, 4, 6)
                    local e = {f(), f(), nil, nil}
                    if (o == 0) then
                        e[t] = f()
                        e[h] = f()
                    elseif (o == #{1}) then
                        e[t] = n()
                    elseif (o == b[2]) then
                        e[t] = n() - (2 ^ 16)
                    elseif (o == b[3]) then
                        e[t] = n() - (2 ^ 16)
                        e[h] = f()
                    end
                    if (l(a, 1, 1) == 1) then
                        e[d] = r[e[d]]
                    end
                    if (l(a, 2, 2) == 1) then
                        e[t] = r[e[t]]
                    end
                    if (l(a, 3, 3) == 1) then
                        e[h] = r[e[h]]
                    end
                    u[s] = e
                end
            end
            return s
        end
        local function y(l, e, n)
            local d = e
            local d = n
            return s(a.CeiUMDEc(a.CeiUMDEc(({a.ZWnERHOQ(l)})[2], e), n))
        end
        local function ee(g, e, r)
            local function ee(...)
                local f, z, p, m, s, n, c, y, k, b, _, l
                local e = 0
                while -1 < e do
                    if e >= 3 then
                        if 5 <= e then
                            if 2 ~= e then
                                for n = 28, 52 do
                                    if 6 > e then
                                        l = o(7)
                                        break
                                    end
                                    e = -2
                                    break
                                end
                            else
                                l = o(7)
                            end
                        else
                            if e ~= 2 then
                                repeat
                                    if 4 > e then
                                        y = {}
                                        k = {...}
                                        break
                                    end
                                    b = a.GLCLOyDB("#", ...) - 1
                                    _ = {}
                                until true
                            else
                                b = a.GLCLOyDB("#", ...) - 1
                                _ = {}
                            end
                        end
                    else
                        if 0 >= e then
                            f = o(6, 10, 1, 58, g)
                            z = o(6, 89, 2, 74, g)
                        else
                            if 0 ~= e then
                                repeat
                                    if 1 < e then
                                        n = -41
                                        c = -1
                                        break
                                    end
                                    p = o(6, 45, 3, 1, g)
                                    s = j
                                    m = 0
                                until true
                            else
                                p = o(6, 45, 3, 1, g)
                                s = j
                                m = 0
                            end
                        end
                    end
                    e = e + 1
                end
                for e = 0, b do
                    if (e >= p) then
                        y[e - p] = k[e + 1]
                    else
                        l[e] = k[e + 1]
                    end
                end
                local e = b - p + 1
                local e
                local o
                local function a(...)
                    while true do
                    end
                end
                while true do
                    if n < -40 then
                        n = n + 42
                    end
                    e = f[n]
                    o = e[ne]
                    if 12 > o then
                        if 5 < o then
                            if o > 8 then
                                if 10 > o then
                                    n = e[t]
                                else
                                    if 10 == o then
                                        local n = e[d]
                                        local d = l[e[t]]
                                        l[n + 1] = d
                                        l[n] = d[e[h]]
                                    else
                                        n = e[t]
                                    end
                                end
                            else
                                if 7 > o then
                                    l[e[d]]()
                                else
                                    if o ~= 7 then
                                        l[e[d]] = (e[t] ~= 0)
                                    else
                                        l[e[d]] = (e[t] ~= 0)
                                    end
                                end
                            end
                        else
                            if o <= 2 then
                                if o <= 0 then
                                    for o = 0, 3 do
                                        if o <= 1 then
                                            if 1 == o then
                                                r[e[t]] = l[e[d]]
                                                n = n + 1
                                                e = f[n]
                                            else
                                                l[e[d]] = (e[t] ~= 0)
                                                n = n + 1
                                                e = f[n]
                                            end
                                        else
                                            if o > -1 then
                                                repeat
                                                    if o ~= 2 then
                                                        if (l[e[d]] == e[h]) then
                                                            n = n + 1
                                                        else
                                                            n = e[t]
                                                        end
                                                        break
                                                    end
                                                    l[e[d]] = r[e[t]]
                                                    n = n + 1
                                                    e = f[n]
                                                until true
                                            else
                                                if (l[e[d]] == e[h]) then
                                                    n = n + 1
                                                else
                                                    n = e[t]
                                                end
                                            end
                                        end
                                    end
                                else
                                    if 0 < o then
                                        for n = 41, 84 do
                                            if 1 ~= o then
                                                l[e[d]]()
                                                break
                                            end
                                            l[e[d]] = r[e[t]]
                                            break
                                        end
                                    else
                                        l[e[d]] = r[e[t]]
                                    end
                                end
                            else
                                if o > 3 then
                                    if o > 3 then
                                        for n = 22, 54 do
                                            if o > 4 then
                                                l[e[d]] = r[e[t]]
                                                break
                                            end
                                            local n = e[d]
                                            local d, e = s(l[n](u(l, n + 1, e[t])))
                                            c = e + n - 1
                                            local e = 0
                                            for n = n, c do
                                                e = e + 1
                                                l[n] = d[e]
                                            end
                                            break
                                        end
                                    else
                                        local n = e[d]
                                        local d, e = s(l[n](u(l, n + 1, e[t])))
                                        c = e + n - 1
                                        local e = 0
                                        for n = n, c do
                                            e = e + 1
                                            l[n] = d[e]
                                        end
                                    end
                                else
                                    local t
                                    t = e[d]
                                    l[t] = l[t](u(l, t + 1, c))
                                    n = n + 1
                                    e = f[n]
                                    l[e[d]]()
                                    n = n + 1
                                    e = f[n]
                                    do
                                        return
                                    end
                                end
                            end
                        end
                    else
                        if 18 <= o then
                            if 20 < o then
                                if o < 23 then
                                    if o > 17 then
                                        for a = 17, 59 do
                                            if o < 22 then
                                                do
                                                    return
                                                end
                                                break
                                            end
                                            if (l[e[d]] == e[h]) then
                                                n = n + 1
                                            else
                                                n = e[t]
                                            end
                                            break
                                        end
                                    else
                                        if (l[e[d]] == e[h]) then
                                            n = n + 1
                                        else
                                            n = e[t]
                                        end
                                    end
                                else
                                    if o > 22 then
                                        for n = 46, 52 do
                                            if 23 < o then
                                                local d = e[d]
                                                local n = l[e[t]]
                                                l[d + 1] = n
                                                l[d] = n[e[h]]
                                                break
                                            end
                                            local e = e[d]
                                            l[e] = l[e](u(l, e + 1, c))
                                            break
                                        end
                                    else
                                        local e = e[d]
                                        l[e] = l[e](u(l, e + 1, c))
                                    end
                                end
                            else
                                if 19 <= o then
                                    if 16 <= o then
                                        for n = 41, 64 do
                                            if 19 < o then
                                                local e = e[d]
                                                l[e] = l[e](u(l, e + 1, c))
                                                break
                                            end
                                            local n = e[d]
                                            local d, e = s(l[n](u(l, n + 1, e[t])))
                                            c = e + n - 1
                                            local e = 0
                                            for n = n, c do
                                                e = e + 1
                                                l[n] = d[e]
                                            end
                                            break
                                        end
                                    else
                                        local n = e[d]
                                        local d, e = s(l[n](u(l, n + 1, e[t])))
                                        c = e + n - 1
                                        local e = 0
                                        for n = n, c do
                                            e = e + 1
                                            l[n] = d[e]
                                        end
                                    end
                                else
                                    r[e[t]] = l[e[d]]
                                end
                            end
                        else
                            if 15 <= o then
                                if o > 15 then
                                    if 14 <= o then
                                        repeat
                                            if o < 17 then
                                                local a, f, r, o, h
                                                local n = 0
                                                while n > -1 do
                                                    if n <= 2 then
                                                        if 1 <= n then
                                                            if -1 < n then
                                                                repeat
                                                                    if n ~= 2 then
                                                                        f = d
                                                                        break
                                                                    end
                                                                    r = t
                                                                until true
                                                            else
                                                                f = d
                                                            end
                                                        else
                                                            a = e
                                                        end
                                                    else
                                                        if n < 5 then
                                                            if 2 <= n then
                                                                for e = 19, 59 do
                                                                    if n ~= 3 then
                                                                        h = a[f]
                                                                        break
                                                                    end
                                                                    o = a[r]
                                                                    break
                                                                end
                                                            else
                                                                o = a[r]
                                                            end
                                                        else
                                                            if 2 < n then
                                                                for e = 12, 87 do
                                                                    if 5 < n then
                                                                        n = -2
                                                                        break
                                                                    end
                                                                    l(h, o)
                                                                    break
                                                                end
                                                            else
                                                                l(h, o)
                                                            end
                                                        end
                                                    end
                                                    n = n + 1
                                                end
                                                break
                                            end
                                            local a, o, r, h, f
                                            local n = 0
                                            while n > -1 do
                                                if n < 3 then
                                                    if 1 > n then
                                                        a = e
                                                    else
                                                        if n ~= -3 then
                                                            for e = 35, 98 do
                                                                if 2 > n then
                                                                    o = d
                                                                    break
                                                                end
                                                                r = t
                                                                break
                                                            end
                                                        else
                                                            o = d
                                                        end
                                                    end
                                                else
                                                    if n <= 4 then
                                                        if 4 > n then
                                                            h = a[r]
                                                        else
                                                            f = a[o]
                                                        end
                                                    else
                                                        if n ~= 3 then
                                                            for e = 20, 84 do
                                                                if 6 ~= n then
                                                                    l(f, h)
                                                                    break
                                                                end
                                                                n = -2
                                                                break
                                                            end
                                                        else
                                                            n = -2
                                                        end
                                                    end
                                                end
                                                n = n + 1
                                            end
                                        until true
                                    else
                                        local o, h, r, a, f
                                        local n = 0
                                        while n > -1 do
                                            if n <= 2 then
                                                if 1 <= n then
                                                    if -1 < n then
                                                        repeat
                                                            if n ~= 2 then
                                                                h = d
                                                                break
                                                            end
                                                            r = t
                                                        until true
                                                    else
                                                        h = d
                                                    end
                                                else
                                                    o = e
                                                end
                                            else
                                                if n < 5 then
                                                    if 2 <= n then
                                                        for e = 19, 59 do
                                                            if n ~= 3 then
                                                                f = o[h]
                                                                break
                                                            end
                                                            a = o[r]
                                                            break
                                                        end
                                                    else
                                                        a = o[r]
                                                    end
                                                else
                                                    if 2 < n then
                                                        for e = 12, 87 do
                                                            if 5 < n then
                                                                n = -2
                                                                break
                                                            end
                                                            l(f, a)
                                                            break
                                                        end
                                                    else
                                                        l(f, a)
                                                    end
                                                end
                                            end
                                            n = n + 1
                                        end
                                    end
                                else
                                    r[e[t]] = l[e[d]]
                                end
                            else
                                if 12 < o then
                                    if o >= 11 then
                                        for a = 16, 58 do
                                            if o > 13 then
                                                if (l[e[d]] == e[h]) then
                                                    n = n + 1
                                                else
                                                    n = e[t]
                                                end
                                                break
                                            end
                                            local c, a
                                            for o = 0, 6 do
                                                if 3 > o then
                                                    if o >= 1 then
                                                        if -2 <= o then
                                                            for a = 41, 71 do
                                                                if o > 1 then
                                                                    r[e[t]] = l[e[d]]
                                                                    n = n + 1
                                                                    e = f[n]
                                                                    break
                                                                end
                                                                l(e[d], e[t])
                                                                n = n + 1
                                                                e = f[n]
                                                                break
                                                            end
                                                        else
                                                            r[e[t]] = l[e[d]]
                                                            n = n + 1
                                                            e = f[n]
                                                        end
                                                    else
                                                        r[e[t]] = l[e[d]]
                                                        n = n + 1
                                                        e = f[n]
                                                    end
                                                else
                                                    if o < 5 then
                                                        if o == 4 then
                                                            l[e[d]] = r[e[t]]
                                                            n = n + 1
                                                            e = f[n]
                                                        else
                                                            l[e[d]] = r[e[t]]
                                                            n = n + 1
                                                            e = f[n]
                                                        end
                                                    else
                                                        if o ~= 5 then
                                                            l(e[d], e[t])
                                                        else
                                                            c = e[d]
                                                            a = l[e[t]]
                                                            l[c + 1] = a
                                                            l[c] = a[e[h]]
                                                            n = n + 1
                                                            e = f[n]
                                                        end
                                                    end
                                                end
                                            end
                                            break
                                        end
                                    else
                                        local a, c
                                        for o = 0, 6 do
                                            if 3 > o then
                                                if o >= 1 then
                                                    if -2 <= o then
                                                        for a = 41, 71 do
                                                            if o > 1 then
                                                                r[e[t]] = l[e[d]]
                                                                n = n + 1
                                                                e = f[n]
                                                                break
                                                            end
                                                            l(e[d], e[t])
                                                            n = n + 1
                                                            e = f[n]
                                                            break
                                                        end
                                                    else
                                                        r[e[t]] = l[e[d]]
                                                        n = n + 1
                                                        e = f[n]
                                                    end
                                                else
                                                    r[e[t]] = l[e[d]]
                                                    n = n + 1
                                                    e = f[n]
                                                end
                                            else
                                                if o < 5 then
                                                    if o == 4 then
                                                        l[e[d]] = r[e[t]]
                                                        n = n + 1
                                                        e = f[n]
                                                    else
                                                        l[e[d]] = r[e[t]]
                                                        n = n + 1
                                                        e = f[n]
                                                    end
                                                else
                                                    if o ~= 5 then
                                                        l(e[d], e[t])
                                                    else
                                                        a = e[d]
                                                        c = l[e[t]]
                                                        l[a + 1] = c
                                                        l[a] = c[e[h]]
                                                        n = n + 1
                                                        e = f[n]
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    do
                                        return
                                    end
                                end
                            end
                        end
                    end
                    n = 1 + n
                end
            end
            return ee
        end
        local d = 0xff
        local h = {}
        local o = (1)
        local t = ""
        (function(n)
            local l = n
            local f = 0x00
            local e = 0x00
            l = {
                (function(a)
                    if f > 0x2f then
                        return a
                    end
                    f = f + 1
                    e = (e + 0x720 - a) % 0x35
                    return (e % 0x03 == 0x0 and (function(l)
                            if not n[l] then
                                e = e + 0x01
                                n[l] = (0x8b)
                                h[o] = le()
                                o = o + d
                            end
                            return true
                        end) "TexjL" and l[0x3](0xc4 + a)) or
                        (e % 0x03 == 0x1 and
                            (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0xe1)
                                    d[2] =
                                        (d[2] *
                                        (y(
                                            function()
                                                h()
                                            end,
                                            u(t)
                                        ) -
                                            y(d[1], u(t)))) +
                                        1
                                    h[o] = {}
                                    d = d[2]
                                    o = o + d
                                end
                                return true
                            end) "fFegA" and
                            l[0x1](a + 0x3d8)) or
                        (e % 0x03 == 0x2 and (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0x8b)
                                    t = "\37"
                                    d = {function()
                                            d()
                                        end}
                                    t = t .. "\100\43"
                                end
                                return true
                            end) "aHlxS" and l[0x2](a + 0x3a4)) or
                        a
                end),
                (function(r)
                    if f > 0x24 then
                        return r
                    end
                    f = f + 1
                    e = (e + 0x1179 - r) % 0x2d
                    return (e % 0x03 == 0x1 and (function(l)
                            if not n[l] then
                                e = e + 0x01
                                n[l] = (0x1f)
                            end
                            return true
                        end) "CoJYy" and l[0x2](0x3a8 + r)) or (e % 0x03 == 0x2 and (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0x9b)
                                end
                                return true
                            end) "OjDjX" and l[0x3](r + 0x2d5)) or (e % 0x03 == 0x0 and (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0xdf)
                                    t = {t .. "\58 a", t}
                                    h[o] = m()
                                    o = o + ((not a.AGmlETZS) and 1 or 0)
                                    t[1] = "\58" .. t[1]
                                    d[2] = 0xff
                                end
                                return true
                            end) "qYHbn" and l[0x1](r + 0xdb)) or r
                end),
                (function(d)
                    if f > 0x24 then
                        return d
                    end
                    f = f + 1
                    e = (e + 0xa4a - d) % 0xd
                    return (e % 0x03 == 0x0 and (function(l)
                            if not n[l] then
                                e = e + 0x01
                                n[l] = (0x1f)
                            end
                            return true
                        end) "BUzGG" and l[0x1](0x239 + d)) or (e % 0x03 == 0x2 and (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0x1d)
                                end
                                return true
                            end) "QFbdf" and l[0x3](d + 0x36b)) or (e % 0x03 == 0x1 and (function(l)
                                if not n[l] then
                                    e = e + 0x01
                                    n[l] = (0x65)
                                end
                                return true
                            end) "RamGD" and l[0x2](d + 0x13a)) or d
                end)
            }
            l[0x1](0x17ce)
        end) {}
        local e = ee(u(h))
        return e(...)
    end
    return m(
        (function()
            local n = {}
            local e = 0x01
            local l
            if a.AGmlETZS then
                l = a.AGmlETZS(m)
            else
                l = ""
            end
            if a.CeiUMDEc(l, a.ssCCAGeZ) then
                e = e + 0
            else
                e = e + 1
            end
            n[e] = 0x02
            n[n[e] + 0x01] = 0x03
            return n
        end)(),
        ...
    )
end)(
    (function(e, n, l, d, t, o)
        local o
        if 3 < e then
            if e < 6 then
                if e ~= 3 then
                    for o = 16, 79 do
                        if e < 5 then
                            local e = d
                            local d, o, t = t(2)
                            do
                                return function()
                                    local l, f, a, n = n(l, e(e, e), e(e, e) + 3)
                                    e(4)
                                    return (n * d) + (a * o) + (f * t) + l
                                end
                            end
                            break
                        end
                        local e = d
                        do
                            return function()
                                local n = n(l, e(e, e), e(e, e))
                                e(1)
                                return n
                            end
                        end
                        break
                    end
                else
                    local e = d
                    do
                        return function()
                            local n = n(l, e(e, e), e(e, e))
                            e(1)
                            return n
                        end
                    end
                end
            else
                if 6 < e then
                    if e ~= 8 then
                        do
                            return setmetatable(
                                {},
                                {["__\99\97\108\108"] = function(e, d, l, t, n)
                                        if n then
                                            return e[n]
                                        elseif t then
                                            return e
                                        else
                                            e[d] = l
                                        end
                                    end}
                            )
                        end
                    else
                        do
                            return l(e, nil, l)
                        end
                    end
                else
                    do
                        return t[l]
                    end
                end
            end
        else
            if e >= 2 then
                if e > -2 then
                    repeat
                        if e < 3 then
                            do
                                return 16777216, 65536, 256
                            end
                            break
                        end
                        do
                            return n(1), n(4, t, d, l, n), n(5, t, d, l)
                        end
                    until true
                else
                    do
                        return 16777216, 65536, 256
                    end
                end
            else
                if e > 0 then
                    do
                        return function(l, e, n)
                            if n then
                                local e = (l / 2 ^ (e - 1)) % 2 ^ ((n - 1) - (e - 1) + 1)
                                return e - e % 1
                            else
                                local e = 2 ^ (e - 1)
                                return (l % (e + e) >= e) and 1 or 0
                            end
                        end
                    end
                else
                    do
                        return n(1), n(4, t, d, l, n), n(5, t, d, l)
                    end
                end
            end
        end
    end),
    ...
)
