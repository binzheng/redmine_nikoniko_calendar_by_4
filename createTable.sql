--
-- テーブルの構造 `nikoniko_histories`
--

CREATE TABLE `nikoniko_histories` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `date` date NOT NULL,
  `niko` char(1) NOT NULL,
  `comment` varchar(140) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `nikoniko_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for table `nikoniko_histories`
--
--
-- ダンプしたテーブルの制約
--

--
-- テーブルの制約 `nikoniko_histories`
--
ALTER TABLE `nikoniko_histories`
  ADD CONSTRAINT `nikoniko_histories_on_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
