# Changelog

## 4.5.0 (2024-06-03)

* [bitnami/grafana-loki] Don't enforce version label when it's not needed ([#26603](https://github.com/bitnami/charts/pull/26603))

## 4.4.0 (2024-06-03)

* [bitnami/grafana-loki] Remove unnecessary memcached image definitions (#26600) ([cd90285](https://github.com/bitnami/charts/commit/cd90285f16d16d9f704aa6260faeac86cc15c529)), closes [#26600](https://github.com/bitnami/charts/issues/26600)

## 4.3.0 (2024-05-29)

* [bitnami/grafana-loki] Enable PodDisruptionBudgets (#26474) ([c03dcf6](https://github.com/bitnami/charts/commit/c03dcf6a0d4551fc2632041969f4e5c08c57ec3a)), closes [#26474](https://github.com/bitnami/charts/issues/26474)

## <small>4.2.1 (2024-05-23)</small>

* [bitnami/grafana-loki] Use different liveness/readiness probes (#26351) ([3dbb011](https://github.com/bitnami/charts/commit/3dbb0111f588082f064a4e8236466924a9b82f80)), closes [#26351](https://github.com/bitnami/charts/issues/26351)

## 4.2.0 (2024-05-21)

* [bitnami/*] ci: :construction_worker: Add tag and changelog support (#25359) ([91c707c](https://github.com/bitnami/charts/commit/91c707c9e4e574725a09505d2d313fb93f1b4c0a)), closes [#25359](https://github.com/bitnami/charts/issues/25359)
* [bitnami/grafana-loki] feat: :sparkles: :lock: Add warning when original images are replaced (#26210 ([d6cd239](https://github.com/bitnami/charts/commit/d6cd239c90b98a0f0393594d83fbf27146119967)), closes [#26210](https://github.com/bitnami/charts/issues/26210)

## <small>4.1.1 (2024-05-18)</small>

* [bitnami/grafana-loki] Release 4.1.1 updating components versions (#26018) ([e958fdc](https://github.com/bitnami/charts/commit/e958fdc0ca7f61cc7caed153b628effa99c98ae8)), closes [#26018](https://github.com/bitnami/charts/issues/26018)

## 4.1.0 (2024-05-16)

* [bitnami/grafana-loki] Network policy review (#25904) ([c6b5d76](https://github.com/bitnami/charts/commit/c6b5d764aeecfe7a32943d6d8ff97318366fc895)), closes [#25904](https://github.com/bitnami/charts/issues/25904)

## <small>4.0.3 (2024-05-13)</small>

* [bitnami/grafana-loki] Release 4.0.3 updating components versions (#25765) ([7af8b37](https://github.com/bitnami/charts/commit/7af8b37f1e90cdb4a9af4eb4c0e1216d6047a9dd)), closes [#25765](https://github.com/bitnami/charts/issues/25765)

## <small>4.0.2 (2024-05-13)</small>

* [bitnami/*] Change non-root and rolling-tags doc URLs (#25628) ([b067c94](https://github.com/bitnami/charts/commit/b067c94f6bcde427863c197fd355f0b5ba12ff5b)), closes [#25628](https://github.com/bitnami/charts/issues/25628)
* [bitnami/grafana-loki] Release 4.0.2 updating components versions (#25720) ([a2c5eb4](https://github.com/bitnami/charts/commit/a2c5eb4d067e3dff80537f06943d684166ca411d)), closes [#25720](https://github.com/bitnami/charts/issues/25720)

## <small>4.0.1 (2024-05-07)</small>

* [bitnami/*] Set new header/owner (#25558) ([8d1dc11](https://github.com/bitnami/charts/commit/8d1dc11f5fb30db6fba50c43d7af59d2f79deed3)), closes [#25558](https://github.com/bitnami/charts/issues/25558)
* [bitnami/grafana-loki] Release 4.0.1 updating components versions (#25599) ([f6008f1](https://github.com/bitnami/charts/commit/f6008f18bab539fa7605c5603294418f7aa66ca2)), closes [#25599](https://github.com/bitnami/charts/issues/25599)
* [bitnami/multiple charts] Fix typo: "NetworkPolice" vs "NetworkPolicy" (#25348) ([6970c1b](https://github.com/bitnami/charts/commit/6970c1ba245873506e73d459c6eac1e4919b778f)), closes [#25348](https://github.com/bitnami/charts/issues/25348)
* Replace VMware by Broadcom copyright text (#25306) ([a5e4bd0](https://github.com/bitnami/charts/commit/a5e4bd0e35e419203793976a78d9d0a13de92c76)), closes [#25306](https://github.com/bitnami/charts/issues/25306)

## 4.0.0 (2024-04-23)

* [bitnami/grafana-loki] Release 4.0.0 (#25308) ([21df419](https://github.com/bitnami/charts/commit/21df419a19c0ca46c92fd12bc5791018cd18c23b)), closes [#25308](https://github.com/bitnami/charts/issues/25308)

## <small>3.2.1 (2024-04-22)</small>

* [bitnami/grafana-loki] Release 3.2.1 updating components versions (#25305) ([758a156](https://github.com/bitnami/charts/commit/758a1566fd566d8987fa32d59d59c74e1f6772dc)), closes [#25305](https://github.com/bitnami/charts/issues/25305)

## 3.2.0 (2024-04-11)

* [bitnami/grafana-loki] fix: :bug: :lock: Expose missing ports in deployment spec (#25077) ([f988b71](https://github.com/bitnami/charts/commit/f988b71cb769a47d43cffa99e6891ce6c37dfa36)), closes [#25077](https://github.com/bitnami/charts/issues/25077)

## <small>3.1.2 (2024-04-10)</small>

* [bitnami/grafana-loki] Release 3.1.2 updating components versions (#25102) ([8bbd49b](https://github.com/bitnami/charts/commit/8bbd49bfabcd496552111b884b07676830c5332e)), closes [#25102](https://github.com/bitnami/charts/issues/25102)

## <small>3.1.1 (2024-04-09)</small>

* [bitnami/grafana-loki] Don't create NetworkPolicy for ruler if ruler is disabled (#25036) ([8b7d32f](https://github.com/bitnami/charts/commit/8b7d32fa6fd5883a641147848e32f641a0d7633a)), closes [#25036](https://github.com/bitnami/charts/issues/25036)

## 3.1.0 (2024-04-08)

* [bitnami/grafana-loki] Add persistence parameters for Grafana Loki's Index Gateway (#24869) ([fca2b29](https://github.com/bitnami/charts/commit/fca2b291e6ffac5560dd116d3d81125089843435)), closes [#24869](https://github.com/bitnami/charts/issues/24869)

## <small>3.0.3 (2024-04-05)</small>

* [bitnami/grafana-loki] Release 3.0.3 updating components versions (#24981) ([5dae947](https://github.com/bitnami/charts/commit/5dae947b981e5c39b4a21ad015f07117eb9ddeb0)), closes [#24981](https://github.com/bitnami/charts/issues/24981)

## <small>3.0.2 (2024-04-04)</small>

* Disable memcached in grafana-loki (#23866) ([41c2dfc](https://github.com/bitnami/charts/commit/41c2dfc55bbca3661811e97c2b4fb2342e054796)), closes [#23866](https://github.com/bitnami/charts/issues/23866)
* Update resourcesPreset comments (#24467) ([92e3e8a](https://github.com/bitnami/charts/commit/92e3e8a507326d2a20a8f10ab3e7746a2ec5c554)), closes [#24467](https://github.com/bitnami/charts/issues/24467)

## <small>3.0.1 (2024-03-22)</small>

* [bitnami/grafana-loki] Release 3.0.1 updating components versions (#24617) ([97a9db5](https://github.com/bitnami/charts/commit/97a9db57b510c8bf5442c393e072c6f2fc5dcea5)), closes [#24617](https://github.com/bitnami/charts/issues/24617)

## 3.0.0 (2024-03-19)

* [bitnami/*] Reorder Chart sections (#24455) ([0cf4048](https://github.com/bitnami/charts/commit/0cf4048e8743f70a9753d460655bd030cbff6824)), closes [#24455](https://github.com/bitnami/charts/issues/24455)
* [bitnami/grafana-loki] feat!: :lock: :boom: Improve security defaults (#24510) ([e412e2a](https://github.com/bitnami/charts/commit/e412e2a97f7154f111ba218803d68879cb746e18)), closes [#24510](https://github.com/bitnami/charts/issues/24510)

## <small>2.19.1 (2024-03-06)</small>

* [bitnami/grafana-loki] Release 2.19.1 updating components versions (#24200) ([ddae293](https://github.com/bitnami/charts/commit/ddae2935f6a278c9b6dacbb803e8c474a6569751)), closes [#24200](https://github.com/bitnami/charts/issues/24200)

## 2.19.0 (2024-03-06)

* [bitnami/grafana-loki] feat: :sparkles: :lock: Add automatic adaptation for Openshift restricted-v2  ([11af78e](https://github.com/bitnami/charts/commit/11af78eefda817fa64901ecf92e92b346a93e53b)), closes [#24088](https://github.com/bitnami/charts/issues/24088)
* [bitnami/grafana-loki] Remove the label `Loki-gossip-member: "true"` from Promtail pods (#23962) ([1c6116c](https://github.com/bitnami/charts/commit/1c6116c62006a9edd86f78623f81388b30d380e1)), closes [#23962](https://github.com/bitnami/charts/issues/23962)

## <small>2.18.1 (2024-02-29)</small>

* [bitnami/grafana-loki] Release 2.18.1 updating components versions (#23978) ([25ad544](https://github.com/bitnami/charts/commit/25ad544c8a51e1439bb427c363dd265ab1c4e9cb)), closes [#23978](https://github.com/bitnami/charts/issues/23978)

## 2.18.0 (2024-02-26)

* [bitnami/grafana-loki] feat: :sparkles: :lock: Add readOnlyRootFilesystem support (#23907) ([96052dd](https://github.com/bitnami/charts/commit/96052dd0146d1c7fcf6b3821fff32c54b4118c3a)), closes [#23907](https://github.com/bitnami/charts/issues/23907)

## <small>2.17.3 (2024-02-22)</small>

* Add TSDB support to grafana-loki chart (#22471) ([5f4dd68](https://github.com/bitnami/charts/commit/5f4dd68b9e13a6da535da72265415562017bc3e5)), closes [#22471](https://github.com/bitnami/charts/issues/22471)

## <small>2.17.2 (2024-02-21)</small>

* [bitnami/grafana-loki] Release 2.17.2 updating components versions (#23760) ([f99e892](https://github.com/bitnami/charts/commit/f99e89238de0ed42381f9cdc815b5d54d8bd1a40)), closes [#23760](https://github.com/bitnami/charts/issues/23760)

## <small>2.17.1 (2024-02-21)</small>

* [bitnami/grafana-loki] Release 2.17.1 updating components versions (#23651) ([eb0e168](https://github.com/bitnami/charts/commit/eb0e1681a23485453326b843e4645e7965e50207)), closes [#23651](https://github.com/bitnami/charts/issues/23651)

## 2.17.0 (2024-02-20)

* [bitnami/grafana-loki] feat: :sparkles: :lock: Add resource preset support (#23455) ([b03da4d](https://github.com/bitnami/charts/commit/b03da4d3d3c700815be1619b05e6af141d260488)), closes [#23455](https://github.com/bitnami/charts/issues/23455)

## 2.16.0 (2024-02-20)

* [bitnami/*] Bump all versions (#23602) ([b70ee2a](https://github.com/bitnami/charts/commit/b70ee2a30e4dc256bf0ac52928fb2fa7a70f049b)), closes [#23602](https://github.com/bitnami/charts/issues/23602)

## 2.15.0 (2024-02-12)

* [bitnami/grafana-loki] feat: :lock: Enable networkPolicy and fix containerSecurityContext (#23261) ([292c9bd](https://github.com/bitnami/charts/commit/292c9bdcc191322c39e2895dfa4e019131b3c3d9)), closes [#23261](https://github.com/bitnami/charts/issues/23261)

## <small>2.14.7 (2024-02-07)</small>

* [bitnami/grafana-loki] Release 2.14.7 updating components versions (#23291) ([13ead51](https://github.com/bitnami/charts/commit/13ead51d5e5b3b7a771d1b0903de21c987dfff23)), closes [#23291](https://github.com/bitnami/charts/issues/23291)

## <small>2.14.6 (2024-02-07)</small>

* [bitnami/grafana-loki] Release 2.14.6 updating components versions (#23226) ([e0deb38](https://github.com/bitnami/charts/commit/e0deb389f59c360654b01d8e40154553db7f000b)), closes [#23226](https://github.com/bitnami/charts/issues/23226)

## <small>2.14.5 (2024-02-03)</small>

* [bitnami/grafana-loki] Release 2.14.5 updating components versions (#23094) ([daad08c](https://github.com/bitnami/charts/commit/daad08ccf9b7096173db212b042e917eafb4fef9)), closes [#23094](https://github.com/bitnami/charts/issues/23094)

## <small>2.14.4 (2024-01-30)</small>

* [bitnami/grafana-loki] Release 2.14.4 updating components versions (#22911) ([c5c8558](https://github.com/bitnami/charts/commit/c5c8558a1df22c2617a4a372cee827bf8d58d176)), closes [#22911](https://github.com/bitnami/charts/issues/22911)

## <small>2.14.3 (2024-01-30)</small>

* [bitnami/grafana-loki] Release 2.14.3 updating components versions (#22846) ([fc5236c](https://github.com/bitnami/charts/commit/fc5236c3765ca819ce0be0cfcf44b55d1b9170c1)), closes [#22846](https://github.com/bitnami/charts/issues/22846)

## <small>2.14.2 (2024-01-24)</small>

* [bitnami/*] Move documentation sections from docs.bitnami.com back to the README (#22203) ([7564f36](https://github.com/bitnami/charts/commit/7564f36ca1e95ff30ee686652b7ab8690561a707)), closes [#22203](https://github.com/bitnami/charts/issues/22203)
* [bitnami/grafana-loki] Release 2.14.2 updating components versions (#22708) ([7270cce](https://github.com/bitnami/charts/commit/7270ccee2d40e44fdcc9b9b7fd69f8628be1db91)), closes [#22708](https://github.com/bitnami/charts/issues/22708)

## <small>2.14.1 (2024-01-24)</small>

* [bitnami/grafana-loki] fix: :bug: Set seLinuxOptions to null for Openshift compatibility (#22593) ([bd8c294](https://github.com/bitnami/charts/commit/bd8c2947b1765353ea0435bab2c4c38f95e331b4)), closes [#22593](https://github.com/bitnami/charts/issues/22593)

## 2.14.0 (2024-01-22)

* [bitnami/grafana-loki] fix: :lock: Move service-account token auto-mount to pod declaration (#22406) ([7b66784](https://github.com/bitnami/charts/commit/7b66784cdeea5a5c9944c1bca58ce9d624a8d019)), closes [#22406](https://github.com/bitnami/charts/issues/22406)

## <small>2.13.1 (2024-01-18)</small>

* [bitnami/grafana-loki] Release 2.13.1 updating components versions (#22288) ([c6a352a](https://github.com/bitnami/charts/commit/c6a352ae836f208ff819678f80347cb244d124de)), closes [#22288](https://github.com/bitnami/charts/issues/22288)

## 2.13.0 (2024-01-16)

* [bitnami/grafana-loki] fix: :lock: Improve podSecurityContext and containerSecurityContext with esse ([5e470c5](https://github.com/bitnami/charts/commit/5e470c5f4c2a22ac0e2b09dd55aaff37b7710cfc)), closes [#22124](https://github.com/bitnami/charts/issues/22124)

## <small>2.12.1 (2024-01-15)</small>

* [bitnami/*] Fix ref links (in comments) (#21822) ([e4fa296](https://github.com/bitnami/charts/commit/e4fa296106b225cf8c82445727c675c7c725e380)), closes [#21822](https://github.com/bitnami/charts/issues/21822)
* [bitnami/grafana-loki] fix: :lock: Do not use the default service account (#22014) ([8af2062](https://github.com/bitnami/charts/commit/8af2062c32f4023153d56cd5df205a82bd8ba8ef)), closes [#22014](https://github.com/bitnami/charts/issues/22014)

## 2.12.0 (2024-01-10)

* [bitnami/grafana-loki] feat: :sparkles: Add seccompProfile to containerSecurityContext (#21914) ([32e4f29](https://github.com/bitnami/charts/commit/32e4f2967b3a55c68d14ad707ec576d32f9170fb)), closes [#21914](https://github.com/bitnami/charts/issues/21914)

## <small>2.11.21 (2024-01-10)</small>

* [bitnami/*] Fix docs.bitnami.com broken links (#21901) ([f35506d](https://github.com/bitnami/charts/commit/f35506d2dadee4f097986e7792df1f53ab215b5d)), closes [#21901](https://github.com/bitnami/charts/issues/21901)
* [bitnami/*] Update copyright: Year and company (#21815) ([6c4bf75](https://github.com/bitnami/charts/commit/6c4bf75dec58fc7c9aee9f089777b1a858c17d5b)), closes [#21815](https://github.com/bitnami/charts/issues/21815)
* [bitnami/grafana-loki] Release 2.11.21 updating components versions (#21938) ([ea1e571](https://github.com/bitnami/charts/commit/ea1e571f1c72d8f2439bcf88275bcc4f1f0948f7)), closes [#21938](https://github.com/bitnami/charts/issues/21938)

## <small>2.11.20 (2023-12-14)</small>

* [bitnami/grafana-loki] Release 2.11.20 updating components versions (#21560) ([164f073](https://github.com/bitnami/charts/commit/164f0737c3fe5379feec764c4cdff6a31446d871)), closes [#21560](https://github.com/bitnami/charts/issues/21560)

## <small>2.11.19 (2023-12-11)</small>

* [bitnami/grafana-loki] Remove default empty dict for rollingUpdate (#21312) ([45ec4b8](https://github.com/bitnami/charts/commit/45ec4b8c3c044aca58a3543585377fa704b61ca2)), closes [#21312](https://github.com/bitnami/charts/issues/21312)

## <small>2.11.18 (2023-12-06)</small>

* [bitnami/grafana-loki] Release 2.11.18 updating components versions (#21428) ([32e59d0](https://github.com/bitnami/charts/commit/32e59d0d717e7ce376a623ee600547d844bb6726)), closes [#21428](https://github.com/bitnami/charts/issues/21428)

## <small>2.11.17 (2023-12-05)</small>

* [bitnami/grafana-loki] Replace deprecated pull secret partial (#21374) ([a9cc392](https://github.com/bitnami/charts/commit/a9cc3929198393d9dc2c300802c8f18ea4493702)), closes [#21374](https://github.com/bitnami/charts/issues/21374)

## <small>2.11.16 (2023-11-21)</small>

* [bitnami/*] Remove relative links to non-README sections, add verification for that and update TL;DR ([1103633](https://github.com/bitnami/charts/commit/11036334d82df0490aa4abdb591543cab6cf7d7f)), closes [#20967](https://github.com/bitnami/charts/issues/20967)
* [bitnami/*] Rename solutions to "Bitnami package for ..." (#21038) ([b82f979](https://github.com/bitnami/charts/commit/b82f979e4fb63423fe6e2192c946d09d79c944fc)), closes [#21038](https://github.com/bitnami/charts/issues/21038)
* [bitnami/grafana-loki] Release 2.11.16 updating components versions (#21119) ([35752b1](https://github.com/bitnami/charts/commit/35752b1a5a727c4e27ff54b04c4d66f03aaf57cd)), closes [#21119](https://github.com/bitnami/charts/issues/21119)
* Update readme-generator links (#21043) ([1581eba](https://github.com/bitnami/charts/commit/1581eba8044d730a763c266f279ac2ac782f764d)), closes [#21043](https://github.com/bitnami/charts/issues/21043)

## <small>2.11.15 (2023-11-09)</small>

* [bitnami/grafana-loki] Release 2.11.15 updating components versions (#20849) ([4f899ed](https://github.com/bitnami/charts/commit/4f899ed99197c3609f78da498b39e0e6ff062979)), closes [#20849](https://github.com/bitnami/charts/issues/20849)

## <small>2.11.14 (2023-11-09)</small>

* [bitnami/grafana-loki] Release 2.11.14 updating components versions (#20840) ([bda87b1](https://github.com/bitnami/charts/commit/bda87b1e5c454ba714c4b47662a5d1de799269dc)), closes [#20840](https://github.com/bitnami/charts/issues/20840)

## <small>2.11.13 (2023-11-09)</small>

* [bitnami/*] Rename VMware Application Catalog (#20361) ([3acc734](https://github.com/bitnami/charts/commit/3acc73472beb6fb56c4d99f929061001205bc57e)), closes [#20361](https://github.com/bitnami/charts/issues/20361)
* [bitnami/*] Skip image's tag in the README files of the Bitnami Charts (#19841) ([bb9a01b](https://github.com/bitnami/charts/commit/bb9a01b65911c87e48318db922cc05eb42785e42)), closes [#19841](https://github.com/bitnami/charts/issues/19841)
* [bitnami/*] Standardize documentation (#19835) ([af5f753](https://github.com/bitnami/charts/commit/af5f7530c1bc8c5ded53a6c4f7b8f384ac1804f2)), closes [#19835](https://github.com/bitnami/charts/issues/19835)
* [bitnami/grafana-loki] Release 2.11.13 updating components versions (#20749) ([51d2a88](https://github.com/bitnami/charts/commit/51d2a88989c3276438fc9681ea64554d97e9413e)), closes [#20749](https://github.com/bitnami/charts/issues/20749)

## <small>2.11.12 (2023-10-16)</small>

* [bitnami/grafana-loki] Release 2.11.12 (#20263) ([9b108f2](https://github.com/bitnami/charts/commit/9b108f2ca9bcd2907722207c8908f0003a06a71e)), closes [#20263](https://github.com/bitnami/charts/issues/20263)

## <small>2.11.11 (2023-10-12)</small>

* [bitnami/grafana-loki] Release 2.11.11 (#20141) ([0d0a94c](https://github.com/bitnami/charts/commit/0d0a94c489abfc551f594f21d1dc46dac08873fc)), closes [#20141](https://github.com/bitnami/charts/issues/20141)

## <small>2.11.10 (2023-10-11)</small>

* [bitnami/grafana-loki] Release 2.11.10 (#20040) ([d2fe002](https://github.com/bitnami/charts/commit/d2fe002d380bff227f38217ea261951f82f39e0b)), closes [#20040](https://github.com/bitnami/charts/issues/20040)

## <small>2.11.9 (2023-10-10)</small>

* [bitnami/grafana-loki] Release 2.11.9 (#19955) ([820ce11](https://github.com/bitnami/charts/commit/820ce112d2755f65b5e7271c2781097eb842e6f1)), closes [#19955](https://github.com/bitnami/charts/issues/19955)

## <small>2.11.8 (2023-10-09)</small>

* [bitnami/grafana-loki] Release 2.11.8 (#19936) ([a7240c9](https://github.com/bitnami/charts/commit/a7240c976749ae6298f0877ffb450db6b768fda5)), closes [#19936](https://github.com/bitnami/charts/issues/19936)

## <small>2.11.7 (2023-10-09)</small>

* [bitnami/*] Update Helm charts prerequisites (#19745) ([eb755dd](https://github.com/bitnami/charts/commit/eb755dd36a4dd3cf6635be8e0598f9a7f4c4a554)), closes [#19745](https://github.com/bitnami/charts/issues/19745)
* [bitnami/grafana-loki] Release 2.11.7 (#19889) ([e04e360](https://github.com/bitnami/charts/commit/e04e360da94b4ff3a0c3c0f687a48f4e4531ebef)), closes [#19889](https://github.com/bitnami/charts/issues/19889)

## <small>2.11.6 (2023-10-03)</small>

* [bitnami/grafana-loki] Release 2.11.6 (#19710) ([87ee161](https://github.com/bitnami/charts/commit/87ee161b2459265c799ea2aea32fd403009839d8)), closes [#19710](https://github.com/bitnami/charts/issues/19710)

## <small>2.11.5 (2023-09-20)</small>

* [bitnami/grafana-loki] Release 2.11.5 (#19435) ([2c1e57f](https://github.com/bitnami/charts/commit/2c1e57fde34a150a685a2b89cd258bebeb94d513)), closes [#19435](https://github.com/bitnami/charts/issues/19435)

## <small>2.11.4 (2023-09-20)</small>

* [bitnami/grafana-loki] Release 2.11.4 (#19431) ([0c931cc](https://github.com/bitnami/charts/commit/0c931cc1f883a1059b034b8349a8a0174fb70515)), closes [#19431](https://github.com/bitnami/charts/issues/19431)

## <small>2.11.3 (2023-09-20)</small>

* [bitnami/grafana-loki] Release 2.11.2 (#19295) ([5051d79](https://github.com/bitnami/charts/commit/5051d7900535a8a2819e463f7e2199140f85750a)), closes [#19295](https://github.com/bitnami/charts/issues/19295)

## <small>2.11.2 (2023-09-19)</small>

* [bitnami/grafana-loki] Use different app.kubernetes.io/version label on subcomponents (#19331) ([7c7b922](https://github.com/bitnami/charts/commit/7c7b922c6f030ee427cd969fce745283977fd2e9)), closes [#19331](https://github.com/bitnami/charts/issues/19331)
* Autogenerate schema files (#19194) ([a2c2090](https://github.com/bitnami/charts/commit/a2c2090b5ac97f47b745c8028c6452bf99739772)), closes [#19194](https://github.com/bitnami/charts/issues/19194)
* Revert "Autogenerate schema files (#19194)" (#19335) ([73d80be](https://github.com/bitnami/charts/commit/73d80be525c88fb4b8a54451a55acd506e337062)), closes [#19194](https://github.com/bitnami/charts/issues/19194) [#19335](https://github.com/bitnami/charts/issues/19335)

## <small>2.11.1 (2023-09-06)</small>

* [bitnami/grafana-loki: Use merge helper]: (#19044) ([9874c63](https://github.com/bitnami/charts/commit/9874c63607cf2c7abd6f48a9d99e8788b513e709)), closes [#19044](https://github.com/bitnami/charts/issues/19044)

## 2.11.0 (2023-08-23)

* [bitnami/grafana-loki] Support for customizing standard labels (#18487) ([b9fd027](https://github.com/bitnami/charts/commit/b9fd0278d07eec2a288075c76b43dcd1b9b87a23)), closes [#18487](https://github.com/bitnami/charts/issues/18487)

## <small>2.10.7 (2023-08-19)</small>

* [bitnami/grafana-loki] Release 2.10.7 (#18663) ([1a0daea](https://github.com/bitnami/charts/commit/1a0daea72205a1052b3a9c021941b29f18b2ce16)), closes [#18663](https://github.com/bitnami/charts/issues/18663)

## <small>2.10.6 (2023-08-17)</small>

* [bitnami/grafana-loki] Release 2.10.6 (#18521) ([df33cab](https://github.com/bitnami/charts/commit/df33cab80e2fb374324d8586a1362aa6f6df3323)), closes [#18521](https://github.com/bitnami/charts/issues/18521)

## <small>2.10.5 (2023-08-12)</small>

* [bitnami/grafana-loki] Release 2.10.5 (#18384) ([939efb0](https://github.com/bitnami/charts/commit/939efb090fa5abcc2a1546785374ceb0e8613f27)), closes [#18384](https://github.com/bitnami/charts/issues/18384)

## <small>2.10.4 (2023-07-25)</small>

* [bitnami/grafana-loki] Release 2.10.4 (#17887) ([19e9eb8](https://github.com/bitnami/charts/commit/19e9eb8cdfd4b5e19abf876b094fa1c7e96287df)), closes [#17887](https://github.com/bitnami/charts/issues/17887)

## <small>2.10.3 (2023-07-22)</small>

* [bitnami/grafana-loki] Release 2.10.3 (#17821) ([62187bd](https://github.com/bitnami/charts/commit/62187bd9efedd5ee5878fb4d664ea829593602a9)), closes [#17821](https://github.com/bitnami/charts/issues/17821)

## <small>2.10.2 (2023-07-21)</small>

* [bitnami/grafana-loki] Release 2.10.2 (#17818) ([a862355](https://github.com/bitnami/charts/commit/a862355a494b28afc5a8f1f82b0d5dd48dd3d1e6)), closes [#17818](https://github.com/bitnami/charts/issues/17818)

## <small>2.10.1 (2023-07-13)</small>

* [bitnami/grafana-loki] Release 2.10.1 (#17640) ([d15538e](https://github.com/bitnami/charts/commit/d15538e48dce134423433da11afb490925354eae)), closes [#17640](https://github.com/bitnami/charts/issues/17640)
* Use os-shell in tempate and Jaeger runtime params (#17557) ([91a49eb](https://github.com/bitnami/charts/commit/91a49eb1e3c81c7b7c6c28d1bc5d6d6ae698c1e2)), closes [#17557](https://github.com/bitnami/charts/issues/17557)

## 2.10.0 (2023-06-26)

* feat(grafana-loki): Add ability to set extra args to all containers (#17317) ([8de0eea](https://github.com/bitnami/charts/commit/8de0eeabd297f2a44fbfed6b715afae7f7dfb640)), closes [#17317](https://github.com/bitnami/charts/issues/17317)
* Add copyright header (#17300) ([da68be8](https://github.com/bitnami/charts/commit/da68be8e951225133c7dfb572d5101ca3d61c5ae)), closes [#17300](https://github.com/bitnami/charts/issues/17300)
* Update charts readme (#17217) ([31b3c0a](https://github.com/bitnami/charts/commit/31b3c0afd968ff4429107e34101f7509e6a0e913)), closes [#17217](https://github.com/bitnami/charts/issues/17217)

## <small>2.9.2 (2023-06-20)</small>

* [bitnami/*] Change copyright section in READMEs (#17006) ([ef986a1](https://github.com/bitnami/charts/commit/ef986a1605241102b3dcafe9fd8089e6fc1201ad)), closes [#17006](https://github.com/bitnami/charts/issues/17006)
* [bitnami/grafana-loki] Release 2.9.2 (#17207) ([e28354e](https://github.com/bitnami/charts/commit/e28354e8eb7f51986d848415fa3c5b0f55233a33)), closes [#17207](https://github.com/bitnami/charts/issues/17207)
* [bitnami/several] Change copyright section in READMEs (#16989) ([5b6a5cf](https://github.com/bitnami/charts/commit/5b6a5cfb7625a751848a2e5cd796bd7278f406ca)), closes [#16989](https://github.com/bitnami/charts/issues/16989)

## <small>2.9.1 (2023-05-21)</small>

* [bitnami/grafana-loki] Release 2.9.1 (#16764) ([ffd8581](https://github.com/bitnami/charts/commit/ffd85818411089d65890410f438cd168eedcfc4a)), closes [#16764](https://github.com/bitnami/charts/issues/16764)
* Add wording for enterprise page (#16560) ([8f22774](https://github.com/bitnami/charts/commit/8f2277440b976d52785ba9149762ad8620a73d1f)), closes [#16560](https://github.com/bitnami/charts/issues/16560)

## 2.9.0 (2023-05-09)

* [bitnami/several] Adapt Chart.yaml to set desired OCI annotations (#16546) ([fc9b18f](https://github.com/bitnami/charts/commit/fc9b18f2e98805d4df629acbcde696f44f973344)), closes [#16546](https://github.com/bitnami/charts/issues/16546)

## <small>2.8.1 (2023-05-09)</small>

* [bitnami/grafana-loki] Release 2.8.1 (#16514) ([986b86e](https://github.com/bitnami/charts/commit/986b86e2c1a4b1e3cf9839dbde9d78fd461d9d5f)), closes [#16514](https://github.com/bitnami/charts/issues/16514)

## 2.8.0 (2023-05-08)

* [bitnami/grafana-loki] apiVersion and kind on volumeClaimTemplates (#16059) ([dd45c26](https://github.com/bitnami/charts/commit/dd45c2630d01cce3537ab3a6aba6077eef655381)), closes [#16059](https://github.com/bitnami/charts/issues/16059)

## <small>2.7.2 (2023-05-03)</small>

* [bitnami/grafana-loki] Release 2.7.2 (#16356) ([4e170aa](https://github.com/bitnami/charts/commit/4e170aabd4d7898937de32067abbee5c388fc3ae)), closes [#16356](https://github.com/bitnami/charts/issues/16356)

## <small>2.7.1 (2023-04-24)</small>

* [bitnami/grafana-loki] Release 2.7.1 (#16206) ([135f9d5](https://github.com/bitnami/charts/commit/135f9d5a4897027e5292f7f53b1c0dadfebc3ed9)), closes [#16206](https://github.com/bitnami/charts/issues/16206)

## 2.7.0 (2023-04-20)

* [bitnami/*] Make Helm charts 100% OCI (#15998) ([8841510](https://github.com/bitnami/charts/commit/884151035efcbf2e1b3206e7def85511073fb57d)), closes [#15998](https://github.com/bitnami/charts/issues/15998)

## <small>2.6.3 (2023-04-14)</small>

* [bitnami/grafana-loki] Release 2.6.3 (#16058) ([797457f](https://github.com/bitnami/charts/commit/797457f46eb720afd609d46701c795a5690e106e)), closes [#16058](https://github.com/bitnami/charts/issues/16058)

## <small>2.6.2 (2023-04-01)</small>

* [bitnami/grafana-loki] Release 2.6.2 (#15867) ([ea491cb](https://github.com/bitnami/charts/commit/ea491cb5826588fe181389988246573eb2ad8133)), closes [#15867](https://github.com/bitnami/charts/issues/15867)

## <small>2.6.1 (2023-03-28)</small>

* [bitnami/grafana-loki] Release 2.6.1 (#15776) ([0905708](https://github.com/bitnami/charts/commit/0905708fd95a15e8a8cca194ce67dfb2c6902d71)), closes [#15776](https://github.com/bitnami/charts/issues/15776)

## 2.6.0 (2023-03-21)

* [bitnami/grafana-loki] Add support for service.headless.annotations (#15429) ([adc123c](https://github.com/bitnami/charts/commit/adc123c1539e65ff99b3410d39b56a3917b50f3c)), closes [#15429](https://github.com/bitnami/charts/issues/15429)

## <small>2.5.10 (2023-03-18)</small>

* [bitnami/charts] Apply linter to README files (#15357) ([0e29e60](https://github.com/bitnami/charts/commit/0e29e600d3adc8b1b46e506eccb3decfab3b4e63)), closes [#15357](https://github.com/bitnami/charts/issues/15357)
* [bitnami/grafana-loki] Release 2.5.10 (#15568) ([81b1328](https://github.com/bitnami/charts/commit/81b13285ee0801b66037a3532fa9d78a522d36dd)), closes [#15568](https://github.com/bitnami/charts/issues/15568)

## <small>2.5.9 (2023-03-01)</small>

* [bitnami/grafana-loki] Release 2.5.9 (#15204) ([a544136](https://github.com/bitnami/charts/commit/a544136cf095ef5063405cf61935ab1fab0bd7ce)), closes [#15204](https://github.com/bitnami/charts/issues/15204)

## <small>2.5.8 (2023-02-24)</small>

* [bitnami/grafana-loki] Release 2.5.8 (#15146) ([03f38b8](https://github.com/bitnami/charts/commit/03f38b88c009cd81f318260d587027628e6527b1)), closes [#15146](https://github.com/bitnami/charts/issues/15146)

## <small>2.5.7 (2023-02-17)</small>

* [bitnami/*] Fix markdown linter issues (#14874) ([a51e0e8](https://github.com/bitnami/charts/commit/a51e0e8d35495b907f3e70dd2f8e7c3bcbf4166a)), closes [#14874](https://github.com/bitnami/charts/issues/14874)
* [bitnami/*] Fix markdown linter issues 2 (#14890) ([aa96572](https://github.com/bitnami/charts/commit/aa9657237ee8df4a46db0d7fdf8a23230dd6902a)), closes [#14890](https://github.com/bitnami/charts/issues/14890)
* [bitnami/*] Remove unexpected extra spaces (#14873) ([c97c714](https://github.com/bitnami/charts/commit/c97c714887380d47eae7bfeff316bf01595ecd1d)), closes [#14873](https://github.com/bitnami/charts/issues/14873)
* [bitnami/grafana-loki] Release 2.5.7 (#14956) ([4a069ce](https://github.com/bitnami/charts/commit/4a069ceddb5550301222d07c4c15b955968783d4)), closes [#14956](https://github.com/bitnami/charts/issues/14956)

## <small>2.5.6 (2023-02-01)</small>

* [bitnami/grafana-loki] Release 2.5.6 (#14705) ([3f60b3e](https://github.com/bitnami/charts/commit/3f60b3ef5b6c4b80e93dd762063a95e1bc74f25a)), closes [#14705](https://github.com/bitnami/charts/issues/14705)

## <small>2.5.5 (2023-01-31)</small>

* [bitnami/*] Change copyright date (#14682) ([add4ec7](https://github.com/bitnami/charts/commit/add4ec701108ac36ed4de2dffbdf407a0d091067)), closes [#14682](https://github.com/bitnami/charts/issues/14682)
* [bitnami/grafana-loki] Don't regenerate self-signed certs on upgrade (#14624) ([df0b556](https://github.com/bitnami/charts/commit/df0b5561a8198b5d0e4ee96bb1d73132d8fdda53)), closes [#14624](https://github.com/bitnami/charts/issues/14624)

## <small>2.5.4 (2023-01-26)</small>

* [bitnami/*] Add license annotation and remove obsolete engine parameter (#14293) ([da2a794](https://github.com/bitnami/charts/commit/da2a7943bae95b6e9b5b4ed972c15e990b69fdb0)), closes [#14293](https://github.com/bitnami/charts/issues/14293)
* [bitnami/*] Change licenses annotation format (#14377) ([0ab7608](https://github.com/bitnami/charts/commit/0ab760862c660fcc78cffadf8e1d8cdd70881473)), closes [#14377](https://github.com/bitnami/charts/issues/14377)
* [bitnami/*] Unify READMEs (#14472) ([2064fb8](https://github.com/bitnami/charts/commit/2064fb8dcc78a845cdede8211af8c3cc52551161)), closes [#14472](https://github.com/bitnami/charts/issues/14472)
* [bitnami/grafana-loki] Release 2.5.4 (#14560) ([935b4e8](https://github.com/bitnami/charts/commit/935b4e8d85334fee877d43d368279bc4eb70d6a2)), closes [#14560](https://github.com/bitnami/charts/issues/14560)

## <small>2.5.3 (2023-01-09)</small>

* [bitnami/grafana-loki] Release 2.5.3 (#14227) ([c74d766](https://github.com/bitnami/charts/commit/c74d766d225e3ea7558ec47d22208f0797d2b547)), closes [#14227](https://github.com/bitnami/charts/issues/14227)

## <small>2.5.2 (2022-12-10)</small>

* [bitnami/grafana-loki] Release 2.5.2 (#13897) ([d69f7e6](https://github.com/bitnami/charts/commit/d69f7e6b9e820d4ce3e18f891d5a6ea81b0fa0e9)), closes [#13897](https://github.com/bitnami/charts/issues/13897)

## <small>2.5.1 (2022-11-24)</small>

* [bitnami/grafana-loki] fix apiversion hardcode for deployment (#13679) ([7b63fd6](https://github.com/bitnami/charts/commit/7b63fd6576b11e45860773a665f0ec0da2583bfe)), closes [#13679](https://github.com/bitnami/charts/issues/13679)

## 2.5.0 (2022-11-14)

* [bitnami/grafana-loki] Release 2.4.10 (#13472) ([30065b1](https://github.com/bitnami/charts/commit/30065b19816f4c7c820292052f3eee5b96ce2b3f)), closes [#13472](https://github.com/bitnami/charts/issues/13472)

## <small>2.4.9 (2022-11-09)</small>

* [bitnami/grafana-loki] Release 2.4.9 (#13431) ([debdef9](https://github.com/bitnami/charts/commit/debdef9d59e3e78ca8c8a855a0ce584148ebae7a)), closes [#13431](https://github.com/bitnami/charts/issues/13431)

## <small>2.4.8 (2022-10-31)</small>

* fix duplicate ServiceAccounts rendered (#13242) ([1c9785f](https://github.com/bitnami/charts/commit/1c9785fa993c8d9937f27d7aefed0c264b40d4d0)), closes [#13242](https://github.com/bitnami/charts/issues/13242)

## <small>2.4.7 (2022-10-26)</small>

* fix ingress ingest (#13120) ([22d51ec](https://github.com/bitnami/charts/commit/22d51ecdd0096700a69cdc9f1b0cd74226b7a843)), closes [#13120](https://github.com/bitnami/charts/issues/13120)

## <small>2.4.6 (2022-10-24)</small>

* [bitnami/*] Use new default branch name in links (#12943) ([a529e02](https://github.com/bitnami/charts/commit/a529e02597d49d944eba1eb0f190713293247176)), closes [#12943](https://github.com/bitnami/charts/issues/12943)
* [bitnami/grafana-loki] Update README to include persistence limitation (#12974) ([f558ddf](https://github.com/bitnami/charts/commit/f558ddf509ee2c98b9c36abd59db06159754a8c9)), closes [#12974](https://github.com/bitnami/charts/issues/12974)
* fix loki config volume hardcode (#13082) ([5764e11](https://github.com/bitnami/charts/commit/5764e11ccb4df0a7bad2e4538385415668859c3a)), closes [#13082](https://github.com/bitnami/charts/issues/13082)

## <small>2.4.5 (2022-10-10)</small>

* [bitnami/grafana-loki]  fixed hardcoded table manager configpath (#12849) ([3b9d21c](https://github.com/bitnami/charts/commit/3b9d21c7887d486df41e4f2e9558a884d73c0a8e)), closes [#12849](https://github.com/bitnami/charts/issues/12849)
* [bitnami/grafana-loki] Release 2.4.5 (#12885) ([5504d8d](https://github.com/bitnami/charts/commit/5504d8dd3e500a7c97d3f9c2d2becbcc89b8d53f)), closes [#12885](https://github.com/bitnami/charts/issues/12885)

## <small>2.4.4 (2022-10-08)</small>

* [bitnami/grafana-loki] Release 2.4.4 (#12864) ([d15bed2](https://github.com/bitnami/charts/commit/d15bed208260935bb0a4892428327cd8c6c07864)), closes [#12864](https://github.com/bitnami/charts/issues/12864)
* Generic README instructions related to the repo (#12792) ([3cf6b10](https://github.com/bitnami/charts/commit/3cf6b10e10e60df4b3e191d6b99aa99a9f597755)), closes [#12792](https://github.com/bitnami/charts/issues/12792)

## <small>2.4.3 (2022-10-03)</small>

* [bitnami/grafana-loki] Use custom probes if given (#12500) ([691b938](https://github.com/bitnami/charts/commit/691b938a304440f9390ad3d0044fc123502cc5cc)), closes [#12500](https://github.com/bitnami/charts/issues/12500) [#12354](https://github.com/bitnami/charts/issues/12354)

## <small>2.4.2 (2022-09-23)</small>

* [bitnami/grafana-loki] Deploy ruler statefulset if ruler.enabled is true (#12631) ([de4703e](https://github.com/bitnami/charts/commit/de4703e6310c77306c8a0fcdb8213a1c98a8dd5e)), closes [#12631](https://github.com/bitnami/charts/issues/12631)

## <small>2.4.1 (2022-09-21)</small>

* [bitnami/grafana-loki] Fix Loki gateway service name reference in gateway ingress (#12608) ([ea23679](https://github.com/bitnami/charts/commit/ea2367950fc9af46e139505b7d8ca2e70e37d589)), closes [#12608](https://github.com/bitnami/charts/issues/12608)

## 2.4.0 (2022-09-14)

* [bitnami/grafana-loki] Add overrideConfiguration to override templated loki configuration (#12417) ([4c5ba40](https://github.com/bitnami/charts/commit/4c5ba40347f81f5ebb319cc542f3a3b6a5dbd422)), closes [#12417](https://github.com/bitnami/charts/issues/12417)

## <small>2.3.3 (2022-09-08)</small>

* [bitnami/grafana-loki] Release 2.3.3 (#12325) ([8731c87](https://github.com/bitnami/charts/commit/8731c87c3f8442d976b7d36bfd56dc6789e138db)), closes [#12325](https://github.com/bitnami/charts/issues/12325)

## <small>2.3.2 (2022-08-23)</small>

* [bitnami/grafana-loki] Update Chart.lock (#12084) ([5714fec](https://github.com/bitnami/charts/commit/5714fec84e25b41094a5940f8ad1f4010c105ea5)), closes [#12084](https://github.com/bitnami/charts/issues/12084)

## <small>2.3.1 (2022-08-22)</small>

* [bitnami/grafana-loki] Update Chart.lock (#11990) ([e545099](https://github.com/bitnami/charts/commit/e545099e75f3bcdc2be108d1acec9ff9ef4f0089)), closes [#11990](https://github.com/bitnami/charts/issues/11990)

## 2.3.0 (2022-08-22)

* [bitnami/grafana-loki] Add support for image digest apart from tag (#11897) ([df5e162](https://github.com/bitnami/charts/commit/df5e16288a0c58ad3e97f941a5d1fae208e33529)), closes [#11897](https://github.com/bitnami/charts/issues/11897)

## <small>2.2.8 (2022-08-09)</small>

* [bitnami/grafana-loki] Release 2.2.8 (#11658) ([6f7c408](https://github.com/bitnami/charts/commit/6f7c408076191934e5da74e0f3a2381561b85902)), closes [#11658](https://github.com/bitnami/charts/issues/11658)

## <small>2.2.7 (2022-08-04)</small>

* [bitnami/grafana-loki] Release 2.2.7 (#11577) ([904e088](https://github.com/bitnami/charts/commit/904e088e7c6e88fb73df6da24cc30cff463935ac)), closes [#11577](https://github.com/bitnami/charts/issues/11577)

## <small>2.2.6 (2022-08-03)</small>

* [bitnami/grafana-loki] Release 2.2.6 (#11536) ([702a206](https://github.com/bitnami/charts/commit/702a2063150254a8c0ddb0fea0f75872d0feff80)), closes [#11536](https://github.com/bitnami/charts/issues/11536)

## <small>2.2.5 (2022-07-27)</small>

* [bitnami/grafana-loki] Release 2.2.5 (#11385) ([6ae8609](https://github.com/bitnami/charts/commit/6ae86095ee06eb0a56ef603b6120c3fc2de5a1ab)), closes [#11385](https://github.com/bitnami/charts/issues/11385)

## <small>2.2.4 (2022-07-27)</small>

* [bitnami/*] Update URLs to point to the new bitnami/containers monorepo (#11352) ([d665af0](https://github.com/bitnami/charts/commit/d665af0c708846192d8d5fb2f5f9ea65dd464ab0)), closes [#11352](https://github.com/bitnami/charts/issues/11352)
* [bitnami/grafana-loki] Release 2.2.4 (#11375) ([73a386c](https://github.com/bitnami/charts/commit/73a386c8cd31eb29b3bb33d184c97c2fffea43d6)), closes [#11375](https://github.com/bitnami/charts/issues/11375)

## <small>2.2.3 (2022-07-18)</small>

* [bitnami/grafana-loki] Release 2.2.3 (#11232) ([91b9e03](https://github.com/bitnami/charts/commit/91b9e03c5dbf9f52784d7468bf448e659ec16de4)), closes [#11232](https://github.com/bitnami/charts/issues/11232)

## <small>2.2.2 (2022-07-18)</small>

* [bitnami/grafana-loki] Bump chart version (#11229) ([3fbf83e](https://github.com/bitnami/charts/commit/3fbf83eb0a3228d1d8fc2f9c96b535a2308115f1)), closes [#11229](https://github.com/bitnami/charts/issues/11229)
* [bitnami/grafana-loki] Fixed incorrect grafana loki compactor PVC name (#11126) ([91c55a2](https://github.com/bitnami/charts/commit/91c55a24369d2bf9dd951f8dc02ec896a043f89e)), closes [#11126](https://github.com/bitnami/charts/issues/11126)

## <small>2.2.1 (2022-07-18)</small>

* [bitnami/grafana-loki] Prettify and unify Chart.yaml (#11219) ([461c01f](https://github.com/bitnami/charts/commit/461c01f74d11a07a43bbf79a872fd468b5bf8a95)), closes [#11219](https://github.com/bitnami/charts/issues/11219)

## 2.2.0 (2022-07-12)

* [bitnami/grafana-loki] Implement query-scheduler configuration (#10668) ([7d83d64](https://github.com/bitnami/charts/commit/7d83d645842756c823b51d2f22c6addcb8baa51d)), closes [#10668](https://github.com/bitnami/charts/issues/10668)

## <small>2.1.7 (2022-07-09)</small>

* [bitnami/grafana-loki] Release 2.1.7 (#11100) ([dff5dbf](https://github.com/bitnami/charts/commit/dff5dbff025c68514b8abf88633c9b2b8f5d52d6)), closes [#11100](https://github.com/bitnami/charts/issues/11100)

## <small>2.1.6 (2022-07-07)</small>

* [bitnami/grafana-loki] Release 2.1.6 (#11072) ([fa1705a](https://github.com/bitnami/charts/commit/fa1705a0fbc8b4457c96b786ae699cd8288e2c4f)), closes [#11072](https://github.com/bitnami/charts/issues/11072)

## <small>2.1.5 (2022-07-06)</small>

* [bitnami/grafana-loki] Release 2.1.5 (#10943) ([4d7b3b3](https://github.com/bitnami/charts/commit/4d7b3b374855f5fdc55f49efd91fadd845464206)), closes [#10943](https://github.com/bitnami/charts/issues/10943)

## <small>2.1.4 (2022-06-10)</small>

* [bitnami/grafana-loki] promtail deploy (#10531) ([7fb54e5](https://github.com/bitnami/charts/commit/7fb54e58f90cdc8e99477d5aed02ae8373f0f28b)), closes [#10531](https://github.com/bitnami/charts/issues/10531)
* [bitnami/grafana-loki] Release 2.1.4 (#10696) ([0e7f30c](https://github.com/bitnami/charts/commit/0e7f30c667ac1f67646dc6a42d99fabe13435f6e)), closes [#10696](https://github.com/bitnami/charts/issues/10696)

## <small>2.1.3 (2022-06-09)</small>

* [bitnami/grafana-loki] fix | Excessive annotations key inside annotations of grafana-loki.gateway de ([42ae970](https://github.com/bitnami/charts/commit/42ae970752f643a538072e285cb05d53ab26188e)), closes [#10615](https://github.com/bitnami/charts/issues/10615)

## <small>2.1.2 (2022-06-07)</small>

* [bitnami/*] Replace Kubeapps URL in READMEs (and kubeapps Chart.yaml) and remove BKPR references (#1 ([c6a7914](https://github.com/bitnami/charts/commit/c6a7914361e5aea6016fb45bf4d621edfd111d32)), closes [#10600](https://github.com/bitnami/charts/issues/10600)
* [bitnami/grafana-loki] Fix topologySpreadConstraints default values (#10625) ([a6747a1](https://github.com/bitnami/charts/commit/a6747a1a24aa074a417d1bc475d402a51e823f75)), closes [#10625](https://github.com/bitnami/charts/issues/10625)

## <small>2.1.1 (2022-06-07)</small>

* [bitnami/grafana-loki] Release 2.1.1 (#10604) ([12ffc78](https://github.com/bitnami/charts/commit/12ffc781a044628dbce936c21b46c196cc46ab97)), closes [#10604](https://github.com/bitnami/charts/issues/10604)

## 2.1.0 (2022-06-02)

* [bitnami/grafana-loki] Fix podAntiAffinity label for indexGateway StatefulSet (#10524) ([3d77a53](https://github.com/bitnami/charts/commit/3d77a533a1765e93aa2fbd3daff709df1c90baa9)), closes [#10524](https://github.com/bitnami/charts/issues/10524)
* [bitnami/grafana-loki] Modify naming of cluster-wide resources (#10538) ([19baeed](https://github.com/bitnami/charts/commit/19baeeda30b8c6f4c12029805cd7c02a51c25a20)), closes [#10538](https://github.com/bitnami/charts/issues/10538)

## <small>2.0.5 (2022-06-01)</small>

* [bitnami/grafana-loki] Replace maintainers email by url (#10522) ([fe34497](https://github.com/bitnami/charts/commit/fe34497e3868928ebbd1dbcc708881b085a95c45)), closes [#10522](https://github.com/bitnami/charts/issues/10522)

## <small>2.0.4 (2022-05-31)</small>

* Fix label selectors (#10500) ([d6fe643](https://github.com/bitnami/charts/commit/d6fe64300d73b59d323d4bba15be67db9989189c)), closes [#10500](https://github.com/bitnami/charts/issues/10500)

## <small>2.0.3 (2022-05-30)</small>

* [bitnami/grafana-loki] Replace base64 --decode with base64 -d (#10494) ([81c75d3](https://github.com/bitnami/charts/commit/81c75d3b6bb51ff0a2ae60115b159d53761bf487)), closes [#10494](https://github.com/bitnami/charts/issues/10494)

## <small>2.0.2 (2022-05-28)</small>

* [bitnami/grafana-loki] Release 2.0.2 (#10436) ([8896734](https://github.com/bitnami/charts/commit/88967340ec31180d2c15313d2449ee1afad03abb)), closes [#10436](https://github.com/bitnami/charts/issues/10436)

## <small>2.0.1 (2022-05-23)</small>

* [bitnami/grafana-loki]: Add memcached image reference (#10367) ([9d7d960](https://github.com/bitnami/charts/commit/9d7d960cf303571b2f8589cf9954c502e3af7d22)), closes [#10367](https://github.com/bitnami/charts/issues/10367)

## 2.0.0 (2022-05-23)

* [bitnami/grafana-loki] Release 2.0.0 (#10343) ([af63ad3](https://github.com/bitnami/charts/commit/af63ad30a3941c6c5f1d48302825984476eef2fa)), closes [#10343](https://github.com/bitnami/charts/issues/10343)

## <small>1.1.5 (2022-05-19)</small>

* [bitnami/grafana-loki] feat: :tada: Add chart (#10281) ([55e92bf](https://github.com/bitnami/charts/commit/55e92bf8700b8e08be3239da4dd245be30bbe213)), closes [#10281](https://github.com/bitnami/charts/issues/10281)
